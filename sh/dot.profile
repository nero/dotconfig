# .profile for POSIX-conformant shells

eval "$(cat .config/environment.d/* | grep -E '^[A-Za-z0-9_]*=' | while read -r line; do
  printf "case \"\$${line%%=*}\" in\n(%s) ;;\n(*) export %s;;\nesac\n" "$(printf "%s\n" "${line#*=}"|sed "s/\${${line%%=*}}/*/g")" "$line"
done)"

test -n "$TMPDIR" && mkdir -p "${TMPDIR}"

has_cmd() {
  command -v "$1" >/dev/null 2>&1
}

# load drop-ins
for f in "$HOME"/.config/*/profile; do
  c=${f%/*}
  has_cmd "${c##*/}" && . "$f"
done
unset c f

# We are done for non-interactive logins
case "$-" in
  (*i*) ;;
  (*) return;;
esac

# some terminals need fixes
if test -e "${HOME}/.config/sh/${TERM}.profile"; then
  . "${HOME}/.config/sh/${TERM}.profile"
fi

# Launch xorg session
if has_cmd i3 && test -z "$DISPLAY" && has_cmd xinit && test -z "$SSH_CONNECTION" && test -z "$TMUX"; then
  startx
fi
