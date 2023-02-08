# .profile for POSIX-conformant shells

# This is for really crappy environments
[ -z "$LOGNAME" ]  && export LOGNAME=$(id -un)
[ -z "$HOME" ]     && eval "export HOME=~$LOGNAME"
[ -z "$LANG" ]     && export LANG=en_US.UTF-8

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
  for i in "/run/user/$(id -u)" "$HOME/.local/run/$(uname -n)" "/tmp/$(id -un)-run"; do
    if mkdir -m 0700 -p "$i" 2>/dev/null && test -w "$i"; then
      export XDG_RUNTIME_DIR=$i
      break
    fi
  done
  unset i
fi

# Register config for interactive shells
test -z "$ENV" && export ENV="${XDG_CONFIG_HOME}/env"

# These shells cant be arsed to look in $ENV
if [ -n "$BASH_VERSION" ]; then
  # Make this shell look after $ENV
  set -o posix
  # For later, non-login shells
  test -e "$HOME/.bashrc" || ln -sn "$ENV" "$HOME/.bashrc"
elif [ -n "$ZSH_VERSION" ]; then
  test -e "$HOME/.zshrc" || ln -sn "$ENV" "$HOME/.zshrc"
fi

# Default extra PATHs
prepend_path() {
  case ":${PATH}:" in
  (*:${1}:*) ;;
  (*) PATH="${1}:${PATH}" ;;
  esac
}
prepend_path "${XDG_CONFIG_HOME}/bin"
prepend_path "${HOME}/.local/bin"

# extra stuff if its both login & interactive
case "$-" in
(*i*)
  # print some kind of machine-identifying banner
  printf "%s %s\n" "$(uname -n)" "$(uptime)"
  # clear screen upon exit
  trap clear EXIT
  ;;
esac

# load drop-ins
for f in "$XDG_CONFIG_HOME"/profile.d/*; do
  [ -e "$f" ] && . "$f"
done
unset f
