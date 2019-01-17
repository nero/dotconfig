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
  for i in "/run/user/$(id -u)" "$HOME/.run/$HOSTNAME" "/tmp/$USER-run"; do
    if test -n "$i" && mkdir -m 0700 -p "$i" 2>/dev/null && test -w "$i"; then
      export XDG_RUNTIME_DIR=$i
      break
    fi
  done
fi

if [ -e ~/.pam_environment ]; then
  eval "$(sed '/^$/d;/^#/d;s/\s.*\(DEFAULT\|OVERRIDE\)=/=/g;s/^/export /' <~/.pam_environment)"
fi

export ENV="$XDG_CONFIG_HOME/shellrc"

for f in "$XDG_CONFIG_HOME"/profile.d/*; do
  [ -e "$f" ] && . "$f"
done

PATH=$(
  (
    echo "$HOME"/bin
    echo "$HOME"/.bin
    echo "${XDG_CONFIG_HOME:-$HOME/.config}/bin"
    echo "$PATH"|tr ':' '\n'
    echo "/usr/sbin"
    echo "/sbin"
  ) | while read p; do ! test -e "$p" || echo "$p"; done | awk '!seen[$0]++' | paste -d ':' -s -
)

[ -n "$BASH_VERSION" ] && . "$ENV"
