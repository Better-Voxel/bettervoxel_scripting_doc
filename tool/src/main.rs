//! bvdocs — the docs-repo tool. `validate` checks the hand-authored
//! content against the engine's API dump (every error collected and
//! printed, exit 1 on any); `generate` validates and then builds the
//! mdBook source tree under `book/` plus the content-merged luau-lsp
//! documentation database. The dump is the only engine interface.

mod content;
mod dump;
mod generate;

use std::path::PathBuf;
use std::process::ExitCode;

fn main() -> ExitCode {
    let mut arguments = std::env::args().skip(1);
    let command = arguments.next().unwrap_or_default();
    let root = PathBuf::from(arguments.next().unwrap_or_else(|| ".".to_string()));
    match command.as_str() {
        "validate" => run(&root, false),
        "generate" => run(&root, true),
        _ => {
            eprintln!("usage: bvdocs <validate|generate> [repo-root]");
            ExitCode::FAILURE
        }
    }
}

fn run(root: &std::path::Path, and_generate: bool) -> ExitCode {
    let dump = match dump::Dump::load(&root.join("model").join("api-dump.json")) {
        Ok(dump) => dump,
        Err(error) => {
            eprintln!("error: {error}");
            return ExitCode::FAILURE;
        }
    };
    let content = match content::Content::load(root, &dump) {
        Ok(content) => content,
        Err(errors) => {
            for error in &errors {
                eprintln!("error: {error}");
            }
            eprintln!("{} validation error(s)", errors.len());
            return ExitCode::FAILURE;
        }
    };
    let (covered, total) = content.coverage(&dump);
    println!(
        "content valid — {covered}/{total} members carry rich content, {} guide(s), \
         engine core {}",
        content.guides.len(),
        dump.core_version
    );
    if !and_generate {
        return ExitCode::SUCCESS;
    }
    match generate::generate(root, &dump, &content) {
        Ok(()) => {
            println!("book generated under book/");
            ExitCode::SUCCESS
        }
        Err(error) => {
            eprintln!("error: generate: {error}");
            ExitCode::FAILURE
        }
    }
}
