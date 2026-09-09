#!/usr/bin/env python3
"""Validate the GitBook page manifest, layout, and generated report registration."""

from __future__ import annotations

import re
import sys
from pathlib import Path
from urllib.parse import unquote

ROOT = Path(__file__).resolve().parent.parent
SUMMARY = ROOT / "SUMMARY.md"
CONFIG = ROOT / ".gitbook.yaml"
EXPECTED_BASELINE_PAGES = 77
LINK_RE = re.compile(r"^\s*-\s+\[[^]]+\]\((?:<([^>]+)>|([^)]*))\)\s*$")


def fail(message: str) -> None:
    print(f"ERROR: {message}", file=sys.stderr)


def has_wide_layout(path: Path) -> bool:
    lines = path.read_text(encoding="utf-8").splitlines()
    if not lines or lines[0].strip() != "---":
        return False

    try:
        end = next(index for index, line in enumerate(lines[1:], start=1) if line.strip() == "---")
    except StopIteration:
        return False

    frontmatter = lines[1:end]
    for index, line in enumerate(frontmatter):
        if re.fullmatch(r"layout:\s*", line):
            for child in frontmatter[index + 1 :]:
                if child and not child[0].isspace():
                    break
                if re.fullmatch(r"\s+width:\s*wide\s*", child):
                    return True
    return False


def summary_pages() -> list[Path]:
    pages: list[Path] = []
    for line_number, line in enumerate(SUMMARY.read_text(encoding="utf-8").splitlines(), start=1):
        match = LINK_RE.match(line)
        if not match:
            continue
        target = unquote((match.group(1) or match.group(2)).strip())
        if not target.lower().endswith(".md"):
            continue
        path = (ROOT / target).resolve()
        if ROOT not in path.parents and path != ROOT:
            fail(f"SUMMARY.md:{line_number} points outside the repository: {target}")
            continue
        pages.append(path)
    return pages


def published_pages() -> set[Path]:
    """Return every user-facing Markdown page in the repository."""
    return {
        path.resolve()
        for path in ROOT.rglob("*.md")
        if path not in {ROOT / "README.md", ROOT / "SUMMARY.md"}
        and not any(part.startswith(".") for part in path.relative_to(ROOT).parts)
    }


def main() -> int:
    errors = 0
    if not CONFIG.is_file():
        fail(".gitbook.yaml is missing")
        errors += 1
    elif CONFIG.read_text(encoding="utf-8") != (
        "root: ./\nstructure:\n  readme: README.md\n  summary: SUMMARY.md\n"
    ):
        fail(".gitbook.yaml does not point to README.md and SUMMARY.md")
        errors += 1
    if not SUMMARY.is_file():
        fail("SUMMARY.md is missing")
        return 1

    pages = summary_pages()
    relative = [page.relative_to(ROOT).as_posix() for page in pages]
    duplicates = sorted({item for item in relative if relative.count(item) > 1})
    if duplicates:
        fail("duplicate SUMMARY.md entries: " + ", ".join(duplicates))
        errors += 1

    if len(pages) < EXPECTED_BASELINE_PAGES:
        fail(f"SUMMARY.md has {len(pages)} Markdown pages; expected at least {EXPECTED_BASELINE_PAGES}")
        errors += 1

    expected = published_pages()
    listed = set(pages)
    missing = sorted(page.relative_to(ROOT).as_posix() for page in expected - listed)
    unexpected = sorted(page.relative_to(ROOT).as_posix() for page in listed - expected)
    if missing:
        fail("published pages missing from SUMMARY.md: " + ", ".join(missing))
        errors += 1
    if unexpected:
        fail("SUMMARY.md contains pages outside the published content set: " + ", ".join(unexpected))
        errors += 1

    # README is the only page whose layout is currently enforced globally.
    # The repository also contains imported Markdown without frontmatter.
    checked = [ROOT / "README.md"]
    for page in checked:
        label = page.relative_to(ROOT).as_posix()
        if not page.is_file():
            fail(f"missing page: {label}")
            errors += 1
            continue
        if not has_wide_layout(page):
            fail(f"page does not use layout.width: wide: {label}")
            errors += 1

    if errors:
        return 1

    print(f"GitBook validation passed: {len(pages)} SUMMARY pages and README.md use wide layout.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
