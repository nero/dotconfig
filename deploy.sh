#!/bin/sh
if test -z "$XDG_CONFIG_HOME"; then
  XDG_CONFIG_HOME=$(dirname "$(readlink -f "$0")")
  unset ENV
fi

if test -z "$ENV"; then
  echo "Run \`. ~/.profile; . \$ENV\` or re-login." >&2
fi

bin_check() {
  unset xorg missing
  command -v startx >/dev/null 2>&1 && xorg=1

  bins="ssh-agent ssh-keygen gpg-agent curl"
  xbins="xrdb setxkbmap xmodmap xset feh i3"

  for bin in $bins ${xorg:+$xbins}; do
    command -v "$bin" >/dev/null 2>&1 || missing="$missing$bin "
  done

  [ -n "$missing" ] && echo "Recommended to install: $missing" >&2
}

cronjobs() {
        dir="$XDG_CONFIG_HOME/periodic"
        cmd=". $XDG_CONFIG_HOME/profile; run-parts"
        [ -e "$dir/15min" ] && \
                echo "*/15 * * * * $cmd $dir/15min"
        [ -e "$dir/hourly" ] && \
                echo "0 * * * * $cmd $dir/hourly"
        [ -e "$dir/daily" ] && \
                echo "0 2 * * * $cmd $dir/daily"
        [ -e "$dir/weekly" ] && \
                echo "0 3 * * 6 $cmd $dir/weekly"
        [ -e "$dir/monthly" ] && \
                echo "0 4 1 * * $cmd $dir/monthly"
}

mkdotsymlink() (
  # $1 is name in $XDG_CONFIG_HOME, $2 is name in $HOME
  cd "$HOME" || exit 1
  # I dont know why the following works reliably
  case "$(stat -c "%F" "$2" 2>/dev/null)" in
  'regular file')
    mv "$2" "$2.old" && \
    echo "Renamed $2 to $2.old" >&2
    ;;
  esac
  ln -sfn "${XDG_CONFIG_HOME##$HOME/}/$1" "$2"
)

setup_symlinks() {
  case "$SHELL" in
  *bash)
    mkdotsymlink profile .bash_profile
    mkdotsymlink shellrc .bashrc
    ;;
  *zsh)
    mkdotsymlink profile .zprofile
    mkdotsymlink shellrc .zshrc
    ;;
  esac
  mkdotsymlink profile .profile

  command -v tmux >/dev/null 2>&1 && \
    mkdotsymlink tmux/tmux.conf .tmux.conf
  command -v startx >/dev/null 2>&1 && \
    mkdotsymlink X/initrc .xinitrc
}

bin_check
setup_symlinks

git config --global user.useConfigOnly true 2>/dev/null

if ! test -e "$XDG_CONFIG_HOME"/crontab && test -n "$(crontab -l)"; then
  crontab -l > "$XDG_CONFIG_HOME"/crontab
fi

(
  cat "$XDG_CONFIG_HOME"/crontab 2>/dev/null
  cronjobs
) | crontab -
