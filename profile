# Config for setting up the environment

[ -z "$USER" ] && export USER=$(whoami)
[ -z "$HOME" ] && eval "export HOME=~$USER"

if [ -z "$XDG_CONFIG_HOME" ] && [ -L "$HOME/.profile" ]; then
  profile=$(readlink "$HOME/.profile")
  case "$profile" in
    (/*) ;;
    (*) profile="$HOME/$profile";;
  esac
  export XDG_CONFIG_HOME="${profile%/*}"
  unset profile
fi

export ENV="$XDG_CONFIG_HOME/shellrc"
export HOSTNAME=$(uname -n)

for i in "$XDG_RUNTIME_DIR" "$HOME/.run/$HOSTNAME" "/tmp/$USER-run"; do
  if test -n "$i" && mkdir -m 0700 -p "$i" && test -w "$i"; then
    XDG_RUNTIME_DIR=$i
    break
  fi
done

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

[ -n "$BASH_VERSION" ] && . "$ENV"
