# Copilot / AI agent instructions

## What this repository is

`redmine_close_button` is a Redmine plugin that adds a **Close** button to the issue
toolbar. It is a view-only plugin: it registers a view hook, renders a partial and
ships a small stylesheet and a jQuery/Prototype script that clones the button into
the issue toolbar. There is no model, controller, route or migration.

Layout:

| Path | Purpose |
| --- | --- |
| `init.rb` | Plugin registration; reads the version from `VERSION` |
| `VERSION` | Single source of truth for the plugin version |
| `CHANGES.md` | Changelog; each released version needs a `### <version>` section |
| `lib/redmine_close_button/hooks.rb` | View listener hooking `view_issues_show_details_bottom` |
| `app/views/issues/_close_button.html.erb` | The hidden button template plus asset tags |
| `assets/javascripts/redmine_close_button.js` | Places the button in the toolbar and submits the form |
| `assets/stylesheets/redmine_close_button.css` | Hides the template button |
| `config/locales/*.yml` | Translations for `button_close` |
| `test/docker/` | Smoke tests running against official Redmine Docker images |

## Supported Redmine versions

Redmine **5.1, 6.0, 6.1 and 7.0**. Any change must keep working on all of them;
CI runs the smoke test for each version. Keep in mind:

* Redmine 5.1+ renders a `span.drdn` dropdown in the contextual toolbar; the button
  is inserted before it.
* Redmine 6+ serves plugin assets through the asset pipeline, so asset file names are
  digested (`redmine_close_button-<digest>.js`). Never assert on undigested names.
* Redmine 7 uses SVG/font icons; do not override global icon classes such as
  `.icon-close` with background images.

## Conventions

* Keep changes minimal and surgical; this is a small plugin with no build step.
* Ruby code uses the existing hash-rocket style (`:key => value`) — match it.
* JavaScript is plain ES5 and must keep working with both the jQuery and the legacy
  Prototype code paths.
* When adding user-visible strings, add the key to **all** files in `config/locales/`.
* Do not add dependencies, gemspecs or build tooling.

## Versioning and releases

* Bump the version in `VERSION` only — `init.rb` reads it at load time.
* Add a matching `### <version>` section at the top of `CHANGES.md` describing the
  change. CI fails if the current `VERSION` has no section in `CHANGES.md`.
* Releases are produced by `.github/workflows/release.yml`: push a `v<version>` tag
  (matching `VERSION`) and it builds `redmine_close_button-<version>.zip` and creates
  a GitHub release using the changelog section as release notes.

## Testing

Docker is required. Run the smoke test locally with:

```bash
test/docker/run.sh          # all supported versions
test/docker/run.sh 7.0      # a single version
```

The script starts the official `redmine:<version>` image with this directory mounted
into `plugins/redmine_close_button`, then runs `test/docker/verify_plugin.rb` via
`rails runner` to assert the plugin registers and that the close button and its
assets are rendered on an issue page. Always run it for the affected versions before
proposing a change to the plugin code.
