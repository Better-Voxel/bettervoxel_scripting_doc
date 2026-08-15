//! Snippet type-checking: every example in the content YAML and every
//! `lua`/`luau` fence in a guide runs through `luau-lsp analyze`
//! against the model's definitions file. An example that stops
//! type-checking after an engine API change turns validation red —
//! samples never rot silently.
//!
//! Snippets are SELF-CONTAINED scripts: the definitions file's globals
//! (`workspace`, `game`, `script`, the constructors) are in scope and
//! nothing else. Nonstrict is the default; a snippet may opt into
//! `--!strict`.

use crate::content::Content;
use std::path::Path;
use std::process::Command;

pub fn check(root: &Path, content: &Content) -> Result<(), Vec<String>> {
    let mut snippets: Vec<(String, String)> = Vec::new();

    for (section, owners) in &content.owners {
        for (owner, owner_content) in owners {
            for (member, member_content) in &owner_content.members {
                for (index, example) in member_content.examples.iter().enumerate() {
                    snippets.push((
                        format!("{section}.{owner}.{member}.{index}"),
                        example.code.clone(),
                    ));
                }
            }
            if let Some(extras) = &owner_content.class {
                for (index, example) in extras.examples.iter().enumerate() {
                    snippets.push((format!("{section}.{owner}.{index}"), example.code.clone()));
                }
            }
        }
    }
    for guide in &content.guides {
        let path = root.join("content").join("guides").join(guide);
        let text = std::fs::read_to_string(&path)
            .map_err(|error| vec![format!("{}: {error}", path.display())])?;
        let stem = guide.strip_suffix(".md").unwrap_or(guide);
        for (index, block) in lua_fences(&text).into_iter().enumerate() {
            snippets.push((format!("guides.{stem}.{index}"), block));
        }
    }
    if snippets.is_empty() {
        return Ok(());
    }

    // The checker is required, not optional: a validator that silently
    // skips its checks lies about what it validated.
    if Command::new("luau-lsp").arg("--version").output().is_err() {
        return Err(vec![
            "luau-lsp is not on PATH — install 1.69.0 from \
             https://github.com/JohnnyMorganz/luau-lsp/releases to type-check the \
             example snippets"
                .to_string(),
        ]);
    }

    let scratch = root.join("target").join("snippets");
    let _ = std::fs::remove_dir_all(&scratch);
    std::fs::create_dir_all(&scratch).map_err(|error| vec![format!("snippets dir: {error}")])?;
    let mut files = Vec::new();
    for (label, code) in &snippets {
        let path = scratch.join(format!("{label}.luau"));
        std::fs::write(&path, code).map_err(|error| vec![format!("{label}: {error}")])?;
        files.push(path);
    }

    let output = Command::new("luau-lsp")
        .arg("analyze")
        .arg(format!(
            "--definitions=@bettervoxel={}",
            root.join("model").join("bettervoxel.d.luau").display()
        ))
        .args(&files)
        .output()
        .map_err(|error| vec![format!("running luau-lsp analyze: {error}")])?;
    if output.status.success() {
        println!("{} example snippet(s) type-check", snippets.len());
        return Ok(());
    }
    let mut report = String::from_utf8_lossy(&output.stdout).into_owned();
    report.push_str(&String::from_utf8_lossy(&output.stderr));
    Err(report
        .lines()
        .filter(|line| !line.trim().is_empty() && !line.starts_with("[INFO]"))
        .map(|line| format!("snippet: {line}"))
        .collect())
}

/// The ```lua / ```luau fenced blocks of a markdown text (other fence
/// languages — json, sh — are not Luau and stay unchecked).
fn lua_fences(text: &str) -> Vec<String> {
    let mut blocks = Vec::new();
    let mut current: Option<String> = None;
    for line in text.lines() {
        match &mut current {
            Some(block) => {
                if line.trim_end() == "```" {
                    blocks.push(current.take().expect("open block"));
                } else {
                    block.push_str(line);
                    block.push('\n');
                }
            }
            None => {
                let fence = line.trim_start();
                if fence == "```lua" || fence == "```luau" {
                    current = Some(String::new());
                }
            }
        }
    }
    blocks
}
