# Config for setting up the environment

[ -z "$USER" ]     && export USER=$(whoami)
[ -z "$HOME" ]     && eval "export HOME=~$USER"
[ -z "$HOSTNAME" ] && export HOSTNAME=$(uname -n)

if [ -z "$XDG_CONFIG_HOME" ]; then
  profile=$(readlink "$HOME/.profile")
  case "$profile" in
    ('') ;;
    (/*) export XDG_CONFIG_HOME="${profile%/*}" ;;
    (*)  export XDG_CONFIG_HOME="$HOME/${profile%/*}" ;;
  esac
fi

if [ -z "$XDG_RUNTIME_DIR" ]; then
  for i in "$HOME/.run/$HOSTNAME" "/tmp/$USER-run"; do
    if test -n "$i" && mkdir -m 0700 -p "$i" && test -w "$i"; then
      export XDG_RUNTIME_DIR=$i
      break
    fi
  done
fi

export ENV="$XDG_CONFIG_HOME/shellrc"

pastebin() (
  [ -n "$1" ] && exec < "$1"
  curl -F'file=@-' http://0x0.st
)

register_path() {
  case ":$PATH:" in
  (*:$1:*) return;;
  (*) PATH="$1:$PATH";
  esac
}

register_path "$HOME"/bin

for f in "$XDG_CONFIG_HOME"/profile.d/*; do
  [ -e "$f" ] && . "$f"
done
