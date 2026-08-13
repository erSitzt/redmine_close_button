# CLAUDE.md

Instructions for Claude Code when working in this repository.

The full project guidance lives in [.github/copilot-instructions.md](.github/copilot-instructions.md)
and applies here as well — read it before making changes.

Quick reference:

* **What this is:** a small, view-only Redmine plugin adding a **Close** button to the
  issue toolbar. No models, controllers, routes or migrations; no build step.
* **Supported Redmine versions:** 5.1, 6.0, 6.1, 7.0.
* **Testing (requires Docker):** `test/docker/run.sh` for all versions, or
  `test/docker/run.sh 7.0` for a single one. Run it for the affected versions before
  finishing a change to plugin code.
* **Versioning:** bump `VERSION` (single source of truth, read by `init.rb`) and add a
  matching `### <version>` section to `CHANGES.md`.
* **Releasing:** push a `v<version>` tag; `.github/workflows/release.yml` builds the
  zip archive and creates the GitHub release.
* **Style:** minimal, surgical changes; hash-rocket Ruby syntax; ES5 JavaScript that
  supports both the jQuery and Prototype code paths; add new locale keys to every file
  in `config/locales/`.
