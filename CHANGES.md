# Redmine Close Issue button

## Changelog

### 0.0.11

- Restore the check mark icon next to the close button: the button now uses Redmine's
  `checked` icon (SVG sprite icon on Redmine 6.0+, `icon-checked` CSS icon on Redmine 5.1).
- The hidden button template is now identified by an id instead of being hidden through
  its class, so the buttons cloned into the toolbar keep Redmine's own icon styling.

### 0.0.10

- The `VERSION` file is now the single source of truth for the plugin version and is read by `init.rb`.
- Added a release workflow that publishes a zipped plugin archive for `v*` tags.
- Added smoke tests running against the official Redmine Docker images (5.1, 6.0, 6.1, 7.0) and a CI workflow running them.
- Added Copilot and Claude Code instructions.

### 0.0.9

- Fix icon rendering on Redmine 7.0: removed global `.icon-close` background-image override that conflicted with Redmine 7's SVG/font icon system.
- Fix button placement on Redmine 5.1+: close button is now inserted before the `…` dropdown (`span.drdn`) so it appears prominently in the toolbar instead of inside the submenu.

### 0.0.8

- Compatibility with Redmine 1.3.x. Thanks to @avkvl.

### 0.0.7

- Code style updated.
- New translations added.

### 0.0.6

- JavaScript error fixed when Redmine configured to automatically update "Done ratio" field. Thanks to [Ilya Pleshakov](https://github.com/da-eto-ya).

### 0.0.5

- New translations added.

### 0.0.4

- Closing of issue now set its progress up to 100% - [Alexey Kuleshov](https://github.com/kulesa).
- Simplified and traditional Chinese translations added.

### 0.0.3

- Plugin now hooks issue page instead of replacing of template to be compatible with upcoming versions of Redmine.
- New translations added.

### 0.0.2

- New translations added.
- Home has been moved to [Undev organization repository](https://github.com/Undev/redmine_close_button).

### 0.0.1

- First public release.

