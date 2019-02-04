#!/bin/sh

fail() { echo "FAIL: $1" >&2; exit 1; }
info() { echo "INFO: $1" >&2; }

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
  dot_ln profile .bash_profile
  dot_ln shellrc .bashrc
  ;;
*/zsh)
  dot_ln profile .zprofile
  dot_ln shellrc .zshrc
  ;;
esac

if command -V i3 >/dev/null || [ -n "$DISPLAY" ]; then
  dot_ln X/initrc .xinitrc
fi

dot_ln profile .profile

git config --global user.useConfigOnly true 2>/dev/null

if test -z "$ENV"; then
  info "Run \`. ~/.profile; . \$ENV\` or re-login." >&2
fi
