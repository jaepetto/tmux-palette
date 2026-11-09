# tmux-palette

A flat, fuzzy command palette for tmux. One key, start typing, press Enter.

```
prefix + P   →   spl   →   Split window vertically
                           Split window horizontally
```

## Why

Tools like herdr or tuios offer a command palette with fuzzy search; tmux has
none. The existing fzf plugins (e.g. [tmux-fzf](https://github.com/sainnhe/tmux-fzf))
open a category menu first (session, window, pane, command, keybinding), then
filter inside that category. Their command list shows raw tmux command names
(`split-window`), not what the binding does.

tmux already knows what its bindings do: `tmux list-keys -N` prints a
description for each one.

```
C-b "       Split window vertically
C-b %       Split window horizontally
C-b z       Zoom the active pane
```

`palette.sh` pipes that list into fzf, looks up the binding for the key you
pick, and runs it. About 12 lines of POSIX sh, no plugin manager.

## Requirements

- tmux ≥ 3.3 (fzf's `--tmux` popup needs it)
- fzf ≥ 0.53 (first version with `--tmux`)

Developed and tested on tmux 3.7b and fzf 0.74.1 (macOS, Homebrew). Older
versions are untested beyond the minimums above.

## Install

```sh
git clone https://github.com/jaepetto/tmux-palette ~/.config/tmux/tmux-palette
```

In `tmux.conf`:

```tmux
bind P run-shell -b "~/.config/tmux/tmux-palette/palette.sh"
```

Reload (`tmux source-file ~/.tmux.conf`), then `prefix` + `P`.

## Adding your own commands

Only bindings that have a description appear. tmux's defaults have one
(87 of 89 in the prefix table on 3.7b). Your own bindings need `-N`:

```tmux
bind -N "Reload config" r source-file ~/.tmux.conf
```

## Testing without a terminal

`PALETTE_FILTER` replaces the interactive picker with `fzf --filter` and takes
the top match:

```sh
PALETTE_FILTER="split horiz" ./palette.sh
```

Run it inside tmux, or point `TMUX` and `TMUX_PANE` at a throwaway server
(`tmux -L test -f /dev/null new-session -d`).

## Limitations

- Prefix table only. Root, copy-mode and other key tables are not listed.
- The selected binding is re-run with `tmux source-file -`. Plain commands
  (splits, zoom, new/next window) are verified; bindings built from `;`
  chains, `if-shell` or format strings are untested.
- `tmux list-keys <key>` returns nothing on tmux 3.7b, so the script finds the
  binding by parsing the full `list-keys` output.

## License

MIT
