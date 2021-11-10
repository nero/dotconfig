# .profile for POSIX-conformant shells

# This is for really crappy environments
[ -z "$USER" ]     && export USER=$(whoami)
[ -z "$HOME" ]     && eval "export HOME=~$USER"
[ -z "$LANG" ]     && export LANG=en_US.UTF-8

# HOSTNAME is not in POSIX, but we will make it globally available
export HOSTNAME=$(uname -n)

# If $XDG_CONFIG_HOME is not set, read where the ~/.profile symlink points to
# and guess directory from that. This is relevant if the etc repo is checked
# out in a place different from ~/.config.
if [ -z "$XDG_CONFIG_HOME" ]; then
  profile=$(readlink "$HOME/.profile")
  case "$profile" in
    ('') ;;
    (/*) export XDG_CONFIG_HOME="${profile%/*}" ;;
    (*)  export XDG_CONFIG_HOME="$HOME/${profile%/*}" ;;
  esac
  unset profile
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
  unset i
fi

# Register config for interactive shells
test -z "$ENV" && export ENV="${XDG_CONFIG_HOME}/env"
test -e "$ENV" || unset ENV

# Default extra PATHs
prepend_path() {
  case ":${PATH}:" in
  (*:${1}:*) ;;
  (*) PATH="${1}:${PATH}" ;;
  esac
}
prepend_path "${XDG_CONFIG_HOME}/bin"
prepend_path "${HOME}/.local/bin"

# clear terminal on logout
case "$-" in
(*i*) trap clear EXIT;;
esac

# If bash loads .profile, .bashrc gets skipped, even for interactive shells.
# This manually sources the shellrc to make sure prompt and such is loaded
[ -n "$BASH_VERSION" ] && . "$ENV"
