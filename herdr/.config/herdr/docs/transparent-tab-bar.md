# Transparent tab bar (keep dracula colors)

**Goal:** keep the dracula theme but let the terminal emulator's transparency
show through the tab bar / panel surfaces — instead of herdr painting an opaque
background over it.

## What was done

Added a `[theme.custom]` override in `config.toml` that resets the panel
background token while leaving the rest of the dracula palette intact:

```toml
[theme]
name = "dracula"
auto_switch = false

[theme.custom]
# Keep dracula colors but let the terminal's transparency show through the
# tab bar / panel surfaces (same effect the "terminal" theme has everywhere).
panel_bg = "reset"
```

## How it works

- herdr color tokens accept **reset aliases**: `reset`, `default`, `none`,
  `transparent`. A reset alias drops that token back to the terminal's *default*
  background, so the emulator's transparency shows through.
- This is the same mechanism the built-in `theme = "terminal"` uses everywhere —
  here it's applied to a single token so dracula's other colors are kept.
- The tab bar is drawn on the `panel_bg` surface, so resetting that one token
  makes the tab bar transparent.

## Applying changes

After editing `config.toml`, reload the running server (no restart needed):

```sh
herdr config check          # validate -> "config: ok"
herdr server reload-config  # apply live -> status "applied"
```

## If the tab bar is still opaque

The tab bar may sit on a different surface token. Add one or more of these
(same `reset` value) and reload again:

```toml
[theme.custom]
panel_bg    = "reset"
surface0    = "reset"
surface_dim = "reset"
sidebar_bg  = "reset"   # also makes the sidebar transparent, if wanted
```

## Notes

- The actual transparency comes from the **terminal emulator** (background
  opacity setting). herdr can only *avoid painting over* it — it can't create
  transparency on its own.
- Reference: herdr config reference
  `theme.custom.*` tokens, v0.9.5
  (https://raw.githubusercontent.com/herdrdev/herdr/v0.9.5/docs/next/website/src/data/config-reference.json)
