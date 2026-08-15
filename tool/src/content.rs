//! The hand-authored content layer: one YAML per documented owner under
//! `content/{classes,datatypes,services}/<Owner>.yaml`, plus markdown
//! guides. The schema is deliberately SLIM — content never restates
//! types (the dump owns them): params are keyed by NAME with prose
//! values, and everything is additive over the model summaries.
//!
//! Unknown YAML fields are ERRORS (`deny_unknown_fields`): a
//! contributor's typo must fail validation, not vanish silently.

use crate::dump::Dump;
use serde::Deserialize;
use std::collections::BTreeMap;
use std::path::Path;

#[derive(Deserialize, Default)]
#[serde(deny_unknown_fields)]
pub struct OwnerContent {
    /// Per-member rich content, keyed by the member name.
    #[serde(default)]
    pub members: BTreeMap<String, MemberContent>,
    /// Page-level extras (rendered after the summary paragraph).
    #[serde(default)]
    pub class: Option<SectionContent>,
}

#[derive(Deserialize, Default)]
#[serde(deny_unknown_fields)]
pub struct MemberContent {
    /// Parameter prose by parameter NAME — legal only on members whose
    /// dump entry carries a parsed signature.
    #[serde(default)]
    pub params: BTreeMap<String, String>,
    /// Return-value prose (one blob — positions stay in the model).
    #[serde(default)]
    pub returns: Option<String>,
    /// Markdown rendered after the summary.
    #[serde(default)]
    pub remarks: Option<String>,
    #[serde(default)]
    pub examples: Vec<Example>,
}

#[derive(Deserialize, Default)]
#[serde(deny_unknown_fields)]
pub struct SectionContent {
    #[serde(default)]
    pub remarks: Option<String>,
    #[serde(default)]
    pub examples: Vec<Example>,
}

#[derive(Deserialize)]
#[serde(deny_unknown_fields)]
pub struct Example {
    pub title: String,
    /// A self-contained Luau script (the definitions file's globals are
    /// in scope) — type-checked by `validate`, and executed by the
    /// engine's doc-example harness when `runnable`.
    pub code: String,
    /// Consumed by the runnable-examples export (stage 4) — schema'd
    /// now so authored content never has to change shape.
    #[allow(dead_code)]
    #[serde(default)]
    pub runnable: bool,
}

/// Everything loaded from `content/`: section → owner name → content.
#[derive(Default)]
pub struct Content {
    pub owners: BTreeMap<&'static str, BTreeMap<String, OwnerContent>>,
    /// Guide file names (`*.md` under `content/guides`), sorted.
    pub guides: Vec<String>,
}

/// Book-root names the generator owns — a guide may not shadow them.
const RESERVED_PAGES: &[&str] = &[
    "README.md",
    "SUMMARY.md",
    "book.toml",
    "enums.md",
    "globals.md",
    "api-dump.json",
    "bettervoxel.d.luau",
    "bettervoxel-docs.json",
];

impl Content {
    /// Loads and VALIDATES the content tree against the dump. Every
    /// problem is collected (not first-error-wins) and returned as one
    /// failure so a contributor sees the whole list.
    pub fn load(root: &Path, dump: &Dump) -> Result<Content, Vec<String>> {
        let mut content = Content::default();
        let mut errors = Vec::new();

        for (section, owners) in dump.sections() {
            let directory = root.join("content").join(section);
            let mut loaded = BTreeMap::new();
            for entry in read_dir_sorted(&directory) {
                let file_name = entry.file_name().to_string_lossy().into_owned();
                let Some(owner_name) = file_name.strip_suffix(".yaml") else {
                    errors.push(format!(
                        "content/{section}/{file_name}: only .yaml files live here"
                    ));
                    continue;
                };
                let Some((_, _, members)) =
                    owners.iter().find(|(name, _, _)| *name == owner_name)
                else {
                    errors.push(format!(
                        "content/{section}/{file_name}: no {section} owner named \
                         {owner_name} in the dump"
                    ));
                    continue;
                };
                let text = match std::fs::read_to_string(entry.path()) {
                    Ok(text) => text,
                    Err(error) => {
                        errors.push(format!("content/{section}/{file_name}: {error}"));
                        continue;
                    }
                };
                let parsed: OwnerContent = match serde_yaml::from_str(&text) {
                    Ok(parsed) => parsed,
                    Err(error) => {
                        errors.push(format!("content/{section}/{file_name}: {error}"));
                        continue;
                    }
                };
                validate_owner(section, owner_name, &parsed, members, &mut errors);
                loaded.insert(owner_name.to_string(), parsed);
            }
            content.owners.insert(section, loaded);
        }

        for entry in read_dir_sorted(&root.join("content").join("guides")) {
            let file_name = entry.file_name().to_string_lossy().into_owned();
            if !file_name.ends_with(".md") {
                errors.push(format!(
                    "content/guides/{file_name}: only .md files live here"
                ));
                continue;
            }
            if RESERVED_PAGES.contains(&file_name.as_str()) {
                errors.push(format!(
                    "content/guides/{file_name}: shadows a generated page — rename it"
                ));
                continue;
            }
            content.guides.push(file_name);
        }

        if errors.is_empty() {
            Ok(content)
        } else {
            Err(errors)
        }
    }

    pub fn member(&self, section: &str, owner: &str, member: &str) -> Option<&MemberContent> {
        self.owners.get(section)?.get(owner)?.members.get(member)
    }

    /// The coverage line `validate` prints: documented member count over
    /// the dump's total (informational — content is additive, never
    /// required).
    pub fn coverage(&self, dump: &Dump) -> (usize, usize) {
        let mut total = 0;
        let mut covered = 0;
        for (section, owners) in dump.sections() {
            for (owner, _, members) in owners {
                for member in members {
                    total += 1;
                    if self.member(section, owner, &member.name).is_some() {
                        covered += 1;
                    }
                }
            }
        }
        (covered, total)
    }
}

fn validate_owner(
    section: &str,
    owner: &str,
    content: &OwnerContent,
    members: &[crate::dump::Member],
    errors: &mut Vec<String>,
) {
    let place = |member: &str| format!("content/{section}/{owner}.yaml: {member}");
    for (member_name, member_content) in &content.members {
        let Some(member) = members.iter().find(|member| member.name == *member_name) else {
            errors.push(format!(
                "{}: no such member on {owner} in the dump",
                place(member_name)
            ));
            continue;
        };
        let signature_params: Vec<&str> = member
            .params
            .as_ref()
            .map(|params| params.iter().map(|param| param.name.as_str()).collect())
            .unwrap_or_default();
        for param_name in member_content.params.keys() {
            if member.params.is_none() {
                errors.push(format!(
                    "{}: params prose on a member without a parsed signature",
                    place(member_name)
                ));
                break;
            }
            if !signature_params.contains(&param_name.as_str()) {
                errors.push(format!(
                    "{}: no parameter named {param_name} (the dump has: {})",
                    place(member_name),
                    signature_params.join(", ")
                ));
            }
        }
        if member_content.returns.is_some()
            && member.returns.as_ref().is_none_or(|returns| returns.is_empty())
        {
            errors.push(format!(
                "{}: returns prose on a member with no return positions",
                place(member_name)
            ));
        }
        for example in &member_content.examples {
            if example.code.trim().is_empty() {
                errors.push(format!(
                    "{}: example \"{}\" has empty code",
                    place(member_name),
                    example.title
                ));
            }
        }
    }
}

/// Directory entries name-sorted (deterministic across platforms); a
/// missing directory is simply empty.
fn read_dir_sorted(directory: &Path) -> Vec<std::fs::DirEntry> {
    let Ok(entries) = std::fs::read_dir(directory) else {
        return Vec::new();
    };
    let mut entries: Vec<_> = entries.flatten().collect();
    entries.sort_by_key(|entry| entry.file_name());
    entries
}
