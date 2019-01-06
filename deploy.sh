#!/bin/sh

fail() { echo "FAIL: $1" >&2; exit 1; }
info() { echo "INFO: $1" >&2; }

ssh_config() {
  config=$HOME/.ssh/config
  touch "$config"
  awk -v n="$1" -v v="$2" -v ws="  " '
/^\s/ { ws=$0;gsub("[^ 	].*", "", ws) }
/^(Host|Match)/ { area=$0 }
{
  if (n && area=="Host *" && $1==n) {
    printf("%s%s %s\n",ws,n,v)
    n=""
  } else {
    print($0)
  }
}
END {
  if (n) {
    if (area!="Host *") {
      print("Host *")
    }
    printf("%s%s %s\n",ws,n,v)
  }
}
' <"$config" >"$config".tmp && mv "$config".tmp "$config"
}

dot_ln() (
  # $1 is name in $XDG_CONFIG_HOME, $2 is name in $HOME
  cd "$HOME" || exit 1
  # I dont know why the following works reliably
  case "$(stat -c "%F" "$2" 2>/dev/null)" in
  'regular file')
    mv "$2" "$2.old" && \
    info "Renamed $2 to $2.old"
    ;;
  esac
  ln -sfn "${XDG_CONFIG_HOME##$HOME/}/$1" "$2"
)

if test -z "$XDG_CONFIG_HOME"; then
  XDG_CONFIG_HOME=$(dirname "$(readlink -f "$0")")
  unset ENV
fi

case "$SHELL" in
*/bash)
  dot_ln shellrc .bash_profile
  dot_ln shellrc .bashrc
  ;;
*/zsh)
  dot_ln profile .zprofile
  dot_ln shellrc .zshrc
  ;;
esac

dot_ln profile .profile

git config --global user.useConfigOnly true 2>/dev/null

ssh_config ServerAliveInterval 60
ssh_config CanonicalizeHostname yes

if ! [ -e ~/.ssh/id_ed25519 ]; then
  ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -C "$USER@$(hostname -f)"
fi

if test -z "$ENV"; then
  info "Run \`. ~/.profile; . \$ENV\` or re-login." >&2
fi
