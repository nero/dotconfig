# Config for setting up the environment across all sessions/applications
# Default file for bourne-like shells
# If the login shell is zsh, .zprofile is a symlink to this file
# If xorg is started via display manager, .xsession must source this manually

# This is for like, really crappy environments
[ -z "$USER" ]     && export USER=$(whoami)
[ -z "$HOME" ]     && eval "export HOME=~$USER"

# HOSTNAME is not in POSIX, but we will make it globally available
export HOSTNAME=$(uname -n)

# If $XDG_CONFIG_HOME is not set, read where the ~/.profile symlink points to
# and guess directory from that. This is relevant if the etc repos is checked
# in a place different from ~/.config.
if [ -z "$XDG_CONFIG_HOME" ]; then
  profile=$(readlink "$HOME/.profile")
  case "$profile" in
    ('') ;;
    (/*) export XDG_CONFIG_HOME="${profile%/*}" ;;
    (*)  export XDG_CONFIG_HOME="$HOME/${profile%/*}" ;;
  esac
fi

# Guess some directory where i can store sockets and pid files
# Like for ssh agent and connection multiplexing
if [ -z "$XDG_RUNTIME_DIR" ]; then
  for i in "/run/user/$(id -u)" "$HOME/.run/$HOSTNAME" "/tmp/$USER-run"; do
    if mkdir -m 0700 -p "$i" 2>/dev/null && test -w "$i"; then
      export XDG_RUNTIME_DIR=$i
      break
    fi
  done
fi

# Interactive posix shells source this on launch. I call this file shellrc.
export ENV="$XDG_CONFIG_HOME/shellrc"

# Load drop-ins (most of them are machine-specific and not tracked here)
for f in "$XDG_CONFIG_HOME"/profile.d/*; do
  [ -e "$f" ] && . "$f"
done

# PATH is a mess usually. This removes non-existing and duplicate dirs from it.
PATH=$(
  (
    echo "$HOME"/bin
    echo "$HOME"/.bin
    echo "$HOME"/.local/bin
    echo "${XDG_CONFIG_HOME:-$HOME/.config}/bin"
    echo "$PATH"|tr ':' '\n'
    echo "/usr/sbin"
    echo "/sbin"
  ) | while read p; do ! test -e "$p" || echo "$p"; done | awk '!seen[$0]++' | paste -d ':' -s -
)

# If bash loads .profile, .bashrc gets skipped, even for interactive shells.
# This manually sources the shellrc to make sure prompt and shit is loaded
[ -n "$BASH_VERSION" ] && . "$ENV"
