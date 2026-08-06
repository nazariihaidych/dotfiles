# Adding new dotfiles configs

How to bring a tool's config under version control in this repo, whether
it's brand new or already sitting in `~/.config` from a fresh install.

Background: every top-level directory except `install/`, `references/`,
and `docs/` is a [Stow](https://www.gnu.org/software/stow/) package. A
package's contents mirror `$HOME` exactly — `foo/.config/foo/bar.conf`
becomes `~/.config/foo/bar.conf` when stowed. `install/install-dotfiles.sh`
has a single `PACKAGES` array that is the source of truth for what gets
stowed on a fresh install — any new package must be added there too.

## Case 1: Tool has no config yet, or you're starting fresh

1. `mkdir -p <pkg>/.config/<tool>` in the repo, mirroring the exact path
   the file(s) should have under `$HOME`.
2. Write/copy the config file(s) in.
3. Add `<pkg>` to the `PACKAGES` array in `install/install-dotfiles.sh`.
4. Stow it: `stow --target="$HOME" --restow <pkg>` (run from the repo root).
5. Verify: `ls -la ~/.config/<tool>` should now be a symlink into the repo.

## Case 2: Tool's config directory already exists as real files

This is the common case — you installed a CLI tool, it wrote defaults (or
you tweaked them) into `~/.config/<tool>`, and now you want it tracked.
`stow` refuses to symlink over existing real files, so the live directory
has to be emptied into the repo first. Concrete steps (this is exactly
what was done for `btop`/`lazydocker`/`lazygit`):

1. **Inspect before tracking anything**: `find ~/.config/<tool>`. Separate
   config you actually authored/tuned from auto-generated runtime noise —
   lock files, UUIDs, first-run markers, or anything the tool's own docs
   say it rewrites on every launch (e.g. htop's `htoprc` literally warns
   "this file is rewritten by htop... not human-friendly"). Don't track
   the noise — it's state, not config, and it'll just generate spurious
   diffs.
2. `mkdir -p <pkg>/.config/<tool>/...` for the parts worth keeping, then
   `cp` (not `mv`, until you've verified the copy) those files in.
3. `rm -rf ~/.config/<tool>` — safe once the copy is confirmed in the repo.
4. `stow --target="$HOME" --restow <pkg>` from the repo root.
5. Add `<pkg>` to `PACKAGES` in `install/install-dotfiles.sh`.
6. Verify the symlink landed: `ls -la ~/.config/<tool>`.

## Case 3: Package already exists, you're just adding a file to it

E.g. `nvim` is already tracked and you want to add a new file under it.

1. Drop the new file directly into the package at the matching relative
   path (`nvim/.config/nvim/lua/newthing.lua` → `~/.config/nvim/lua/newthing.lua`).
2. Re-run `stow --target="$HOME" --restow <pkg>`. If stow already folded
   the whole directory into one symlink, the new file just appears with
   no extra step — restowing is idempotent either way, so it's always
   safe to run again if unsure.

## When the config directory also holds runtime state

Some tools write continuously to the *same* directory they keep config
in — history files, session data, plugin clones, caches, lock files. If
you naively track the whole directory, Stow's default "folding" behavior
collapses it into a single symlink, which points the tool's live writes
at this git repo instead of a real directory. That's actively harmful,
not just untidy: `zsh` (plugin git-clones into `$ZDOTDIR/plugins`),
`herdr` (writes its own lock file), and `claude` (statusline script
tracked out of Claude Code's much larger live `~/.claude` state dir) all
hit this.

Signal that you need this: `find ~/.config/<tool>` turns up files you
didn't create sitting *alongside* genuine config — growing logs, session
databases, lock files, anything with a timestamp or UUID in it.

Fix: stow that package with `--no-folding`, which keeps the parent
directory real on disk and symlinks in only the specific tracked
files/subdirs. This needs a dedicated `case` arm in the loop in
`install/install-dotfiles.sh` (see the existing `claude` and
`zsh | herdr` cases) — add one for your package with a comment
explaining which live-written path motivated it, same as those.

## Before committing

- `git status` — confirm only the files you intend are new/modified,
  nothing swept in by accident.
- `bash -n install/install-dotfiles.sh` (or any shell script you touched).
- Dry-run each touched package against a scratch target, never live
  `$HOME` if real files still exist there:
  `stow --target=/tmp/scratch-home --simulate --verbose=1 <pkg>`.
- If you launched the app interactively to test something (capture help
  text, confirm a setting), check whether it auto-saves its config on
  exit — some tools silently rewrite the tracked file with incidental
  state from your test session (e.g. btop's `save_config_on_exit` will
  persist whatever process-sort-column or filter you happened to leave
  active). Diff the file afterward and revert anything that wasn't an
  intentional change.
