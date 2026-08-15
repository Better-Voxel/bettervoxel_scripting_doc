//! The book generator: dump + content → `book/` (the mdBook source
//! tree) plus the content-merged luau-lsp documentation database. The
//! page shapes are a faithful port of the engine's original emitters —
//! with EMPTY content the class/datatype/service/enums/globals/README
//! pages must come out byte-identical to the engine-emitted ones (the
//! stage-2 parity gate); content only ever ADDS sections.

use crate::content::{Content, Example, MemberContent};
use crate::dump::{Class, Dump, Member};
use serde_json::{Map, Value, json};
use std::collections::BTreeMap;
use std::fmt::Write as _;
use std::fs;
use std::io;
use std::path::Path;

/// The definitions-file package name — must match the engine's emitter
/// and the editor-setup guide.
const PACKAGE: &str = "@bettervoxel";

/// The published site — `learn_more_link` targets.
const SITE: &str = "https://better-voxel.github.io/bettervoxel_scripting_doc/";

/// The mdBook configuration for the generated tree: the book source is
/// `book/` (gitignored, regenerated whole), output under `target/`.
const BOOK_TOML: &str = "[book]\n\
    title = \"BetterVoxel scripting API\"\n\
    language = \"en\"\n\
    src = \".\"\n\
    \n\
    [build]\n\
    build-dir = \"../target/book\"\n\
    create-missing = false\n";

pub fn generate(root: &Path, dump: &Dump, content: &Content) -> io::Result<()> {
    let book = root.join("book");
    if book.exists() {
        fs::remove_dir_all(&book)?;
    }
    for directory in ["classes", "datatypes", "services"] {
        fs::create_dir_all(book.join(directory))?;
    }

    fs::write(book.join("book.toml"), BOOK_TOML)?;
    fs::write(book.join("SUMMARY.md"), emit_summary(dump, content))?;
    fs::write(book.join("README.md"), emit_index(dump, content))?;
    for class in &dump.classes {
        fs::write(
            book.join("classes").join(format!("{}.md", class.name)),
            emit_class_page(dump, class, content),
        )?;
    }
    for (section, owners) in [("datatypes", &dump.datatypes), ("services", &dump.services)] {
        for owner in owners {
            fs::write(
                book.join(section).join(format!("{}.md", owner.name)),
                emit_standalone_page(section, &owner.name, &owner.summary, &owner.members, content),
            )?;
        }
    }
    fs::write(book.join("enums.md"), emit_enums(dump))?;
    fs::write(book.join("globals.md"), emit_globals(dump))?;

    // The model files ride into the site verbatim — except the docs
    // database, which regenerates here WITH the authored content.
    for model_file in ["api-dump.json", "bettervoxel.d.luau"] {
        fs::copy(root.join("model").join(model_file), book.join(model_file))?;
    }
    fs::write(
        book.join("bettervoxel-docs.json"),
        emit_docs_json(dump, content),
    )?;

    for guide in &content.guides {
        fs::copy(
            root.join("content").join("guides").join(guide),
            book.join(guide),
        )?;
    }

    // The runnable-examples manifest — what the engine's doc-example
    // harness executes against the standard scaffold place.
    let mut runnable = Vec::new();
    for (section, owners) in &content.owners {
        for (owner, owner_content) in owners {
            for (member, member_content) in &owner_content.members {
                for (index, example) in member_content.examples.iter().enumerate() {
                    if example.runnable {
                        runnable.push(json!({
                            "id": format!("{section}.{owner}.{member}.{index}"),
                            "code": example.code,
                        }));
                    }
                }
            }
            if let Some(extras) = &owner_content.class {
                for (index, example) in extras.examples.iter().enumerate() {
                    if example.runnable {
                        runnable.push(json!({
                            "id": format!("{section}.{owner}.{index}"),
                            "code": example.code,
                        }));
                    }
                }
            }
        }
    }
    fs::create_dir_all(root.join("target"))?;
    let mut manifest =
        serde_json::to_string_pretty(&Value::Array(runnable)).expect("plain data");
    manifest.push('\n');
    fs::write(root.join("target").join("runnable-examples.json"), manifest)?;
    Ok(())
}

fn emit_summary(dump: &Dump, content: &Content) -> String {
    let mut out =
        String::from("# Summary\n\n[BetterVoxel scripting API](README.md)\n\n");
    if !content.guides.is_empty() {
        out.push_str("# Guides\n\n");
        for guide in &content.guides {
            let title = guide_title(guide);
            let _ = writeln!(out, "- [{title}]({guide})");
        }
        out.push('\n');
    }
    out.push_str("# Classes\n\n");
    let mut children: BTreeMap<Option<&str>, Vec<&Class>> = BTreeMap::new();
    for class in &dump.classes {
        children
            .entry(class.parent.as_deref())
            .or_default()
            .push(class);
    }
    fn push_tree(
        out: &mut String,
        children: &BTreeMap<Option<&str>, Vec<&Class>>,
        parent: Option<&str>,
        depth: usize,
    ) {
        let Some(rows) = children.get(&parent) else {
            return;
        };
        for row in rows {
            let _ = writeln!(
                out,
                "{}- [{}](classes/{}.md)",
                "  ".repeat(depth),
                row.name,
                row.name
            );
            push_tree(out, children, Some(row.name.as_str()), depth + 1);
        }
    }
    push_tree(&mut out, &children, None, 0);
    out.push_str("\n# Services\n\n");
    for owner in &dump.services {
        let _ = writeln!(out, "- [{0}](services/{0}.md)", owner.name);
    }
    out.push_str("\n# Datatypes\n\n");
    for owner in &dump.datatypes {
        let _ = writeln!(out, "- [{0}](datatypes/{0}.md)", owner.name);
    }
    out.push_str("\n# Reference\n\n- [Enums](enums.md)\n- [Globals](globals.md)\n");
    out
}

/// A guide's SUMMARY title: the file stem with dashes opened and the
/// first letter raised (`editor-setup.md` → "Editor setup").
fn guide_title(file_name: &str) -> String {
    let stem = file_name.strip_suffix(".md").unwrap_or(file_name);
    let opened = stem.replace('-', " ");
    let mut characters = opened.chars();
    match characters.next() {
        Some(first) => first.to_uppercase().collect::<String>() + characters.as_str(),
        None => opened,
    }
}

fn emit_index(dump: &Dump, content: &Content) -> String {
    let mut out = String::from(
        "# BetterVoxel scripting API\n\n\
         Generated from the engine's pinned API model — regenerate with\n\
         `cargo test -p bv_engine_core --features docgen --test api_surface`.\n\
         The Luau declaration file for IDEs is\n\
         [`bettervoxel.d.luau`](bettervoxel.d.luau).\n\n",
    );
    if !content.guides.is_empty() {
        out.push_str("## Guides\n\n");
        for guide in &content.guides {
            let _ = writeln!(out, "- [{}]({guide})", guide_title(guide));
        }
        out.push('\n');
    }
    out.push_str("## Classes\n\n");
    let mut children: BTreeMap<Option<&str>, Vec<&Class>> = BTreeMap::new();
    for class in &dump.classes {
        children
            .entry(class.parent.as_deref())
            .or_default()
            .push(class);
    }
    fn push_tree(
        out: &mut String,
        children: &BTreeMap<Option<&str>, Vec<&Class>>,
        parent: Option<&str>,
        depth: usize,
    ) {
        let Some(rows) = children.get(&parent) else {
            return;
        };
        for row in rows {
            let mark = if row.creatable {
                ""
            } else {
                " *(not creatable)*"
            };
            let _ = writeln!(
                out,
                "{}- [{}](classes/{}.md){mark}",
                "  ".repeat(depth),
                row.name,
                row.name
            );
            push_tree(out, children, Some(row.name.as_str()), depth + 1);
        }
    }
    push_tree(&mut out, &children, None, 0);

    out.push_str(
        "\n## Services\n\nStandalone objects `game:GetService` hands out (the DataModel \
         is `game` itself);\nthe container services — ReplicatedStorage and friends — \
         are ordinary\ninstances and need no pages of their own.\n\n",
    );
    for owner in &dump.services {
        let _ = writeln!(out, "- [{0}](services/{0}.md)", owner.name);
    }
    out.push_str("\n## Datatypes\n\n");
    for owner in &dump.datatypes {
        let _ = writeln!(out, "- [{0}](datatypes/{0}.md)", owner.name);
    }
    out.push_str("\n## Reference\n\n- [Enums](enums.md)\n- [Globals](globals.md)\n");
    out
}

/// One member's book section — the ported shape, plus the content
/// additions (parameter table, returns line, remarks, examples).
fn push_member_section(
    out: &mut String,
    member: &Member,
    content: Option<&MemberContent>,
) {
    match member.kind.as_str() {
        "ReadWrite" => {
            let _ = writeln!(
                out,
                "### {}\n\n`{}` — read/write\n",
                member.name, member.decl
            );
        }
        "ReadOnly" => {
            let _ = writeln!(
                out,
                "### {}\n\n`{}` — read-only\n",
                member.name, member.decl
            );
        }
        "Signal" => {
            let fires = member
                .payloads
                .as_deref()
                .unwrap_or_default()
                .join(", ");
            let _ = writeln!(out, "### {}\n\nFires with `({fires})`\n", member.name);
        }
        _ => {
            let _ = writeln!(out, "### {}\n\n`{}`\n", member.name, member.decl);
        }
    }
    let _ = writeln!(out, "{}\n", member.summary);

    let Some(content) = content else {
        return;
    };
    if !content.params.is_empty() {
        if let Some(params) = &member.params {
            out.push_str("| Parameter | Description |\n|---|---|\n");
            for param in params {
                let prose = content
                    .params
                    .get(&param.name)
                    .map(String::as_str)
                    .unwrap_or("—");
                let _ = writeln!(
                    out,
                    "| `{}: {}` | {} |",
                    param.name,
                    param.ty,
                    prose.replace('\n', " ").trim()
                );
            }
            out.push('\n');
        }
    }
    if let Some(returns) = &content.returns {
        let _ = writeln!(out, "**Returns:** {}\n", returns.trim());
    }
    if let Some(remarks) = &content.remarks {
        let _ = writeln!(out, "{}\n", remarks.trim_end());
    }
    push_examples(out, &content.examples);
}

fn push_examples(out: &mut String, examples: &[Example]) {
    for example in examples {
        let _ = writeln!(out, "#### {}\n", example.title);
        let _ = writeln!(out, "```lua\n{}\n```\n", example.code.trim_end());
    }
}

/// The Properties/Methods/Events/Constructors sections for one owner.
fn push_member_groups_for(
    out: &mut String,
    section: &str,
    owner: &str,
    members: &[Member],
    content: &Content,
) {
    for (title, kinds) in [
        ("Constructors", &["Static"][..]),
        ("Properties", &["ReadWrite", "ReadOnly"][..]),
        ("Methods", &["Method"][..]),
        ("Events", &["Signal"][..]),
    ] {
        let selected: Vec<&Member> = members
            .iter()
            .filter(|member| kinds.contains(&member.kind.as_str()))
            .collect();
        if selected.is_empty() {
            continue;
        }
        let _ = writeln!(out, "## {title}\n");
        for member in selected {
            push_member_section(out, member, content.member(section, owner, &member.name));
        }
    }
}

fn emit_class_page(dump: &Dump, class: &Class, content: &Content) -> String {
    let mut out = String::new();
    let _ = writeln!(out, "# {}\n", class.name);
    let ancestors = dump.ancestors(&class.name);
    if !ancestors.is_empty() {
        let chain: Vec<String> = ancestors
            .iter()
            .map(|ancestor| format!("[{ancestor}]({ancestor}.md)"))
            .collect();
        let _ = writeln!(out, "*Inherits {}*\n", chain.join(" < "));
    }
    let creation = if class.creatable {
        format!("Creatable with `Instance.new(\"{}\")`.", class.name)
    } else if dump
        .classes
        .iter()
        .any(|other| other.parent.as_deref() == Some(class.name.as_str()))
    {
        "Not creatable: a base class other classes inherit from.".to_string()
    } else {
        "Not creatable: the engine spawns it.".to_string()
    };
    let _ = writeln!(out, "{creation}\n");
    let _ = writeln!(out, "{}\n", class.summary);
    push_owner_extras(&mut out, "classes", &class.name, content);

    push_member_groups_for(&mut out, "classes", &class.name, &class.members, content);

    let inherited: Vec<String> = ancestors
        .iter()
        .filter_map(|ancestor| {
            let members = &dump
                .classes
                .iter()
                .find(|class| class.name == **ancestor)?
                .members;
            let names: Vec<&str> = members
                .iter()
                .filter(|member| member.kind != "Static")
                .map(|member| member.name.as_str())
                .collect();
            (!names.is_empty())
                .then(|| format!("- from [{ancestor}]({ancestor}.md): {}", names.join(", ")))
        })
        .collect();
    if !inherited.is_empty() {
        let _ = writeln!(out, "## Inherited members\n");
        for line in inherited {
            let _ = writeln!(out, "{line}");
        }
    }
    out
}

fn emit_standalone_page(
    section: &str,
    name: &str,
    summary: &str,
    members: &[Member],
    content: &Content,
) -> String {
    let mut out = String::new();
    let _ = writeln!(out, "# {name}\n");
    let _ = writeln!(out, "{summary}\n");
    push_owner_extras(&mut out, section, name, content);
    push_member_groups_for(&mut out, section, name, members, content);
    out
}

/// The page-level content additions, after the summary paragraph.
fn push_owner_extras(out: &mut String, section: &str, owner: &str, content: &Content) {
    let Some(extras) = content
        .owners
        .get(section)
        .and_then(|owners| owners.get(owner))
        .and_then(|owner_content| owner_content.class.as_ref())
    else {
        return;
    };
    if let Some(remarks) = &extras.remarks {
        let _ = writeln!(out, "{}\n", remarks.trim_end());
    }
    push_examples(out, &extras.examples);
}

fn emit_enums(dump: &Dump) -> String {
    let mut out = String::from(
        "# Enums\n\nItems in name order; `EnumItem.Value` is an engine-internal index.\n\n",
    );
    for (name, items) in &dump.enums {
        let _ = writeln!(out, "## Enum.{name}\n");
        for item in items {
            let _ = writeln!(out, "- `{item}`");
        }
        out.push('\n');
    }
    out
}

fn emit_globals(dump: &Dump) -> String {
    let notes: BTreeMap<&str, &str> = BTreeMap::from([
        (
            "workspace",
            "the Workspace root — an [Instance](classes/Instance.md)",
        ),
        (
            "game",
            "the [DataModel](services/DataModel.md): `game:GetService(name)` hands \
             out the engine services",
        ),
        (
            "Instance",
            "[Instance](classes/Instance.md) construction: `Instance.new`",
        ),
        ("CFrame", "the [CFrame](datatypes/CFrame.md) constructors"),
        ("Color3", "the [Color3](datatypes/Color3.md) constructors"),
        ("UDim2", "the [UDim2](datatypes/UDim2.md) constructors"),
        (
            "Vector3",
            "the [Vector3](datatypes/Vector3.md) constructors and constants",
        ),
        (
            "TweenInfo",
            "the [TweenInfo](datatypes/TweenInfo.md) constructor",
        ),
        ("Enum", "the [enum](enums.md) tables"),
        (
            "task",
            "the scheduler library (`spawn`/`defer`/`wait` on the engine clock) — \
             not yet in the API model",
        ),
        (
            "Signals",
            "the cross-script signal service table — not yet in the API model",
        ),
        (
            "Keybinds",
            "the keybind action service table — not yet in the API model",
        ),
        (
            "vector",
            "Luau's native vector library — [Vector3](datatypes/Vector3.md) is the \
             same type",
        ),
        (
            "require",
            "loads a [ModuleScript](classes/ModuleScript.md) and caches its result",
        ),
    ]);
    const LUAU_STDLIB: &[&str] = &[
        "_G",
        "_VERSION",
        "assert",
        "bit32",
        "collectgarbage",
        "coroutine",
        "error",
        "gcinfo",
        "getfenv",
        "getmetatable",
        "ipairs",
        "loadstring",
        "math",
        "newproxy",
        "next",
        "os",
        "pairs",
        "pcall",
        "print",
        "rawequal",
        "rawget",
        "rawlen",
        "rawset",
        "select",
        "setfenv",
        "setmetatable",
        "string",
        "table",
        "tonumber",
        "tostring",
        "type",
        "typeof",
        "unpack",
        "utf8",
        "warn",
        "xpcall",
    ];
    let mut out = String::from(
        "# Globals\n\nEverything a script's environment starts with.\n\n## Engine globals\n\n",
    );
    let mut stdlib: Vec<&str> = Vec::new();
    let mut plain: Vec<&str> = Vec::new();
    for global in &dump.globals {
        if let Some(note) = notes.get(global.as_str()) {
            let _ = writeln!(out, "- `{global}` — {note}");
        } else if LUAU_STDLIB.contains(&global.as_str()) {
            stdlib.push(global);
        } else {
            plain.push(global);
        }
    }
    if !plain.is_empty() {
        let _ = writeln!(out, "\n## Other globals\n");
        for global in plain {
            let _ = writeln!(out, "- `{global}`");
        }
    }
    let _ = writeln!(
        out,
        "\n## Luau standard library\n\n{}\n",
        stdlib
            .iter()
            .map(|name| format!("`{name}`"))
            .collect::<Vec<_>>()
            .join(", ")
    );
    out
}

// ---------------------------------------------------------------------------
// The content-merged luau-lsp documentation database — the port of the
// engine's emitter, with authored prose replacing the typed spellings
// where it exists. Same symbols, same invariants (params always beside
// returns; symbol closure).
// ---------------------------------------------------------------------------

fn emit_docs_json(dump: &Dump, content: &Content) -> String {
    let mut entries: Map<String, Value> = Map::new();
    let mut constructor_tables: Map<String, Value> = Map::new();

    for (section, owners) in dump.sections() {
        for (name, summary, members) in owners {
            let page = format!("{SITE}{section}/{name}.html");
            let mut keys = Map::new();
            let mut statics = Map::new();
            for member in members {
                let member_content = content.member(section, name, &member.name);
                if member.kind == "Static" {
                    let symbol = format!("{PACKAGE}/global/{name}.{}", member.name);
                    statics.insert(member.name.clone(), json!(symbol));
                    push_member_docs(&mut entries, &symbol, member, member_content, &page);
                } else {
                    let symbol = format!("{PACKAGE}/globaltype/{name}.{}", member.name);
                    keys.insert(member.name.clone(), json!(symbol));
                    push_member_docs(&mut entries, &symbol, member, member_content, &page);
                }
            }
            let mut type_entry = Map::new();
            type_entry.insert("documentation".to_string(), json!(summary));
            type_entry.insert("learn_more_link".to_string(), json!(page));
            if !keys.is_empty() {
                type_entry.insert("keys".to_string(), Value::Object(keys));
            }
            entries.insert(
                format!("{PACKAGE}/globaltype/{name}"),
                Value::Object(type_entry),
            );
            if !statics.is_empty() {
                constructor_tables.insert(
                    format!("{PACKAGE}/global/{name}"),
                    json!({
                        "documentation":
                            format!("The {name} constructors — see the {name} page."),
                        "learn_more_link": page,
                        "keys": statics,
                    }),
                );
            }
        }
    }
    entries.append(&mut constructor_tables);

    for (symbol, text, page) in [
        (
            "workspace",
            "The Workspace root — the container every world object lives under.",
            "classes/Workspace.html",
        ),
        (
            "game",
            "The DataModel: `game:GetService(name)` hands out the engine services.",
            "services/DataModel.html",
        ),
        (
            "script",
            "The running script's own Instance — `script.Parent` navigates from it.",
            "classes/Instance.html",
        ),
        (
            "Enum",
            "The enum families; every item is an EnumItem.",
            "enums.html",
        ),
        (
            "warn",
            "Prints its arguments to the output as a warning (an engine global — \
             plain Luau has no `warn`).",
            "globals.html",
        ),
    ] {
        entries.insert(
            format!("{PACKAGE}/global/{symbol}"),
            json!({
                "documentation": text,
                "learn_more_link": format!("{SITE}{page}"),
            }),
        );
    }

    verify_docs(&entries);
    let mut out =
        serde_json::to_string_pretty(&Value::Object(entries)).expect("docs database is plain data");
    out.push('\n');
    out
}

fn push_member_docs(
    entries: &mut Map<String, Value>,
    symbol: &str,
    member: &Member,
    content: Option<&MemberContent>,
    page: &str,
) {
    let mut entry = Map::new();
    let documentation = match content.and_then(|content| content.remarks.as_ref()) {
        Some(remarks) => format!("{}\n\n{}", member.summary, remarks.trim()),
        None => member.summary.clone(),
    };
    entry.insert("documentation".to_string(), json!(documentation));
    entry.insert(
        "learn_more_link".to_string(),
        json!(format!("{page}#{}", member.name.to_ascii_lowercase())),
    );
    if let Some(example) = content.and_then(|content| content.examples.first()) {
        entry.insert("code_sample".to_string(), json!(example.code.trim_end()));
    }
    if let Some(params) = &member.params {
        let mut param_refs = Vec::new();
        for (index, param) in params.iter().enumerate() {
            let sub = format!("{symbol}/param/{index}");
            param_refs.push(json!({
                "name": param.name,
                "documentation": sub,
            }));
            let prose = content
                .and_then(|content| content.params.get(&param.name))
                .map(|prose| prose.trim().to_string())
                .unwrap_or_else(|| format!("`{}: {}`", param.name, param.ty));
            entries.insert(sub, json!({ "documentation": prose }));
        }
        let mut return_refs = Vec::new();
        for (index, position) in member
            .returns
            .as_deref()
            .unwrap_or_default()
            .iter()
            .enumerate()
        {
            let sub = format!("{symbol}/return/{index}");
            return_refs.push(json!(sub));
            let prose = content
                .and_then(|content| content.returns.as_ref())
                .filter(|_| index == 0)
                .map(|prose| prose.trim().to_string())
                .unwrap_or_else(|| format!("`{}`", position.ty));
            entries.insert(sub, json!({ "documentation": prose }));
        }
        // ALWAYS the pair — luau-lsp aborts the whole database on a
        // returns-only entry.
        entry.insert("params".to_string(), json!(param_refs));
        entry.insert("returns".to_string(), json!(return_refs));
    }
    entries.insert(symbol.to_string(), Value::Object(entry));
}

fn verify_docs(entries: &Map<String, Value>) {
    for (symbol, entry) in entries {
        assert!(
            entry.get("returns").is_none() || entry.get("params").is_some(),
            "{symbol} carries returns without params"
        );
        for target in entry
            .get("keys")
            .and_then(Value::as_object)
            .into_iter()
            .flat_map(Map::values)
            .chain(
                entry
                    .get("returns")
                    .and_then(Value::as_array)
                    .into_iter()
                    .flatten(),
            )
            .chain(
                entry
                    .get("params")
                    .and_then(Value::as_array)
                    .into_iter()
                    .flatten()
                    .filter_map(|param| param.get("documentation")),
            )
        {
            let target = target.as_str().expect("symbol reference");
            assert!(
                entries.contains_key(target),
                "{symbol} references {target}, which has no entry"
            );
        }
    }
}
