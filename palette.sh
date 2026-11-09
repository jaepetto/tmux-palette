#!/bin/sh
# Fuzzy palette over described tmux prefix bindings; runs the selected one.
# Test hook: PALETTE_FILTER=<query> takes the top match non-interactively.
list=$(tmux list-keys -N -T prefix)
if [ -n "$PALETTE_FILTER" ]; then
  sel=$(printf '%s\n' "$list" | fzf --filter "$PALETTE_FILTER" | head -1)
else
  sel=$(printf '%s\n' "$list" | fzf --tmux center,60%,50% --reverse --prompt 'tmux> ')
fi
[ -n "$sel" ] || exit 0
key=$(printf '%s' "$sel" | awk '{print $2}')
cmd=$(tmux list-keys -T prefix | sed -E 's/^bind-key +(-r +)?-T prefix +//' \
  | awk -v k="$key" '{kk=$1; sub(/^\\/,"",kk)} kk==k {print; exit}' | sed -E 's/^[^ ]+ +//')
printf '%s\n' "$cmd" | tmux source-file -
