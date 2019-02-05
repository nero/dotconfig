#!/bin/sh

fail() { echo "FAIL: $1" >&2; exit 1; }
warn() { echo "WARN: $1" >&2; }
info() { echo "INFO: $1" >&2; }

typestat() {
  stat -c "%F" "$1" 2>/dev/null || echo "none"
}

maybe() {
  info "Command: $*"
  [ "$dry" = 1 ] || "$@"
}

[ "$1" = "-n" ] && dry=1

cd ~

while read dotname class realm; do
  tagex=$(printf "%s\n" "$realm"|sed 's/[_=\-]/./g')
  cfg=${realm:+$realm/}$(printf "%s\n" "$dotname"|sed "s|^\.||;s|^$tagex||;s|^[_\.\-]||")

  case "$class" in
  data)		loc="${XDG_DATA_DIR:-$HOME/.local/share}";;
  conf)		loc="${XDG_CONFIG_HOME:-$HOME/.config}";;
  cache)	loc="${XDG_CACHE_HOME:-$HOME/.cache}";;
  secret)	continue;;
  *)		fail "Unknown class $class";;
  esac

  target="$loc/$cfg"
  name="$HOME/$dotname"

  # data files wont be touched due to rename() updating
  [ -f "$name" ] && [ "$class" = "data" ] && continue

  case "$(typestat "$name")-$(typestat "$target")" in
  'none'-'none'|'symbolic link'-'none') # neither dotfile nor alternative present?
    continue
    ;;
  'none'-*|'symbolic link'-*) # dotfile does not exist or is just a symlink
    ;;
  'regular file'-'none'|'directory'-'none') # move dotfile into alternate location, create symlink
    maybe mkdir -p "${target%/*}"
    maybe mv "$name" "$target"
    ;;
  *-*) # some thing we didn't expect
    warn "Unsure what do do with $name and $target"
    continue
    ;;
  esac

  case "$name" in
  "$HOME"/*)
    case "$target" in
    "$HOME"/*)
      up=$(printf "%s\n" "${name##$HOME/}"|sed 's|[^/]*||g;s|/|../|g')
      target="$up${target##$HOME/}"
      ;;
    esac
    ;;
  esac

  [ "$(readlink "$name")" = "$target" ] && continue
  maybe ln -sfn "$target" "$name"

done <"${XDG_CONFIG_HOME}/dotfiles"
