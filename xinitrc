#!/bin/sh

fail() {
  echo "FAIL: $1" >&2
  exit 1
}

cmd_exists() {
  command -v "$1" >/dev/null 2>&1
}

test -z "$DISPLAY" && fail "No display found"

# Disable that annoying bell
xset b off

# Keyboard setup: disable caps lock
setxkbmap us
xmodmap - <<EOF
clear Lock
keycode 65 = space Multi_key space
keycode 66 = Shift_L NoSymbol Shift_L
EOF

uicolor='#d2738a'
test -f "$HOME"/.config/color && uicolor=$(printf "#%02X%02X%02X" $(cat "$HOME"/.config/color))

# black background
xsetroot -solid black

# Load Xresources
(
  cat "$HOME"/.config/Xresources
  printf "uicolor: %s\n" "$uicolor"
) | xrdb

# Load drop-ins (most of them are machine-specific and not tracked here)
for f in "$HOME"/.config/xinitrc.d/*; do
  [ -e "$f" ] && . "$f"
done
unset f

# Handle reload with i3
case "$I3SOCK/$DESKTOP_STARTUP_ID" in
(*/i3*) i3-msg restart && exit 0;;
esac

# Bail out if window manager already running
# This is required because i use this script to reload my settings
test -n "$WINDOWID" && fail "Not starting another window manager"

# Try around until we got something
# If no sane WM found, run xorg with bare terminal.
for session in i3 xfce4-session x-terminal-emulator; do
  cmd_exists "$session" && exec "$session"
done

fail "$0 failed to launch graphical session"
