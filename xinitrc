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

# Set wallpaper (yes, XPM images are actually C code)
xsetroot -bg '#d2738a' -bitmap /dev/stdin <<EOF
#define grey11_width 16
#define grey11_height 16
static char grey11_bits[] = {
0xee,0xee,0x55,0x55,0xfb,0xfb,0x55,0x55,0xee,0xee,0x55,0x55,
0xbf,0xbf,0x55,0x55,0xee,0xee,0x55,0x55,0xfb,0xfb,0x55,0x55,
0xee,0xee,0x55,0x55,0xbf,0xbf,0x55,0x55};
EOF

# Load Xresources
xrdb "$XDG_CONFIG_HOME"/Xresources

# Load drop-ins (most of them are machine-specific and not tracked here)
for f in "$XDG_CONFIG_HOME"/xinitrc.d/*; do
  [ -e "$f" ] && . "$f"
done
unset f

# Handle reload with i3
case "$DESKTOP_STARTUP_ID" in
(i3/*) i3-msg restart && exit 0;;
esac

# Bail out if window manager already running
# This is required because i use this script to reload my settings
test -n "$WINDOWID" && fail "Not starting another window manager"

# Try around until we got something
# If no sane WM found, run xorg with bare terminal.
for session in i3 xfce4-session xterm x-terminal-emulator rxvt-unicode; do
  cmd_exists "$session" && exec "$session"
done

fail "$0 failed to launch graphical session"
