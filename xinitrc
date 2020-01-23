#!/bin/sh

fail() {
  echo "FAIL: $1" >&2
  exit 1
}

cmd_exists() {
  type "$1" >/dev/null 2>&1
}

test -z "$DISPLAY" && fail "No xorg found"

# Themeing
xrdb "$XDG_CONFIG_HOME"/Xresources

# Keyboard setup
setxkbmap us
xmodmap - <<EOF
clear Lock
keycode 65 = space Multi_key space
keycode 66 = Shift_L NoSymbol Shift_L
EOF

# Disable that annoying bell
xset b off

# Set wallpaper
feh --no-fehbg --bg-fill "$XDG_CONFIG_HOME"/wallpaper

test -n "$DESKTOP_STARTUP_ID" && fail "Not starting another window manager"

# Try around until we got something
for session in i3 xfce4-session "$TERMINAL"; do
  cmd_exists "$session" && exec "$session"
done

fail "$0 gives up"
