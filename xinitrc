#!/bin/sh

fail() {
  echo "FAIL: $1" >&2
  exit 1
}

cmd_exists() {
  command -v "$1" >/dev/null 2>&1
}

test -z "$DISPLAY" && fail "No display found"

# Load drop-ins (most of them are machine-specific and not tracked here)
for f in "$XDG_CONFIG_HOME"/xinitrc.d/*; do
  [ -e "$f" ] && . "$f"
done

fail "$0 failed to launch graphical session"
