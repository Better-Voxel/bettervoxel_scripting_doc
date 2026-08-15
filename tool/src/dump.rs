//! The engine's API dump (`model/api-dump.json`), typed. The dump is
//! the ONLY interface to the engine: everything the generator and the
//! validator know comes from here, never from engine source. Unknown
//! fields are tolerated (a newer engine may add data), but an unknown
//! `dump_format` is refused loudly.

use serde::Deserialize;
use std::collections::BTreeMap;

/// The format this tool understands. The engine bumps its side on any
/// breaking shape change; refusing a mismatch beats misreading it.
pub const SUPPORTED_DUMP_FORMAT: u32 = 1;

#[derive(Deserialize)]
pub struct Dump {
    pub dump_format: u32,
    pub core_version: String,
    pub classes: Vec<Class>,
    pub datatypes: Vec<Owner>,
    pub services: Vec<Owner>,
    pub enums: BTreeMap<String, Vec<String>>,
    pub globals: Vec<String>,
}

/// One class of the tree section — `parent`/`creatable` drive the
/// ancestry chain and the creation line.
#[derive(Deserialize)]
pub struct Class {
    pub name: String,
    pub parent: Option<String>,
    pub creatable: bool,
    pub summary: String,
    pub members: Vec<Member>,
}

/// A datatype or service page owner (no tree ancestry).
#[derive(Deserialize)]
pub struct Owner {
    pub name: String,
    pub summary: String,
    pub members: Vec<Member>,
}

/// One member. `params`/`returns` are present exactly when the decl is
/// one signature (methods and arrow statics); `overloads` when it is an
/// intersection; `payloads` on signals.
#[derive(Deserialize)]
pub struct Member {
    pub name: String,
    pub kind: String,
    pub decl: String,
    pub summary: String,
    #[serde(default)]
    pub params: Option<Vec<Param>>,
    #[serde(default)]
    pub returns: Option<Vec<Return>>,
    #[serde(default)]
    pub payloads: Option<Vec<String>>,
    /// Deserialized for schema completeness; no page renders overload
    /// structure yet (the decl text carries it).
    #[allow(dead_code)]
    #[serde(default)]
    pub overloads: Option<Vec<Overload>>,
}

#[derive(Deserialize)]
pub struct Param {
    pub name: String,
    #[serde(rename = "type")]
    pub ty: String,
    #[allow(dead_code)]
    pub optional: bool,
}

#[derive(Deserialize)]
pub struct Return {
    #[serde(rename = "type")]
    pub ty: String,
}

#[derive(Deserialize)]
pub struct Overload {
    #[allow(dead_code)]
    pub params: Vec<Param>,
    #[allow(dead_code)]
    pub returns: Vec<Return>,
}

impl Dump {
    pub fn load(path: &std::path::Path) -> Result<Dump, String> {
        let text = std::fs::read_to_string(path)
            .map_err(|error| format!("cannot read {}: {error}", path.display()))?;
        let dump: Dump = serde_json::from_str(&text)
            .map_err(|error| format!("cannot parse {}: {error}", path.display()))?;
        if dump.dump_format != SUPPORTED_DUMP_FORMAT {
            return Err(format!(
                "dump_format {} is not the supported {} — update the tool (or the model sync \
                 delivered a newer engine's dump)",
                dump.dump_format, SUPPORTED_DUMP_FORMAT
            ));
        }
        Ok(dump)
    }

    /// Root-first ancestry chain of `class`, excluding the class itself.
    pub fn ancestors(&self, class: &str) -> Vec<&str> {
        let parent_of = |name: &str| {
            self.classes
                .iter()
                .find(|row| row.name == name)
                .and_then(|row| row.parent.as_deref())
        };
        let mut chain = Vec::new();
        let mut cursor = parent_of(class);
        while let Some(parent) = cursor {
            chain.push(parent);
            cursor = parent_of(parent);
        }
        chain
    }

    /// The three page sections as (section directory, owners) — the
    /// shape both the validator and the generator iterate.
    pub fn sections(&self) -> [(&'static str, Vec<(&str, &str, &[Member])>); 3] {
        let class_owners: Vec<(&str, &str, &[Member])> = self
            .classes
            .iter()
            .map(|class| (class.name.as_str(), class.summary.as_str(), &class.members[..]))
            .collect();
        let datatype_owners: Vec<(&str, &str, &[Member])> = self
            .datatypes
            .iter()
            .map(|owner| (owner.name.as_str(), owner.summary.as_str(), &owner.members[..]))
            .collect();
        let service_owners: Vec<(&str, &str, &[Member])> = self
            .services
            .iter()
            .map(|owner| (owner.name.as_str(), owner.summary.as_str(), &owner.members[..]))
            .collect();
        [
            ("classes", class_owners),
            ("datatypes", datatype_owners),
            ("services", service_owners),
        ]
    }
}
