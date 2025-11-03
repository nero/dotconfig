# .profile for POSIX-conformant shells

# The variables are possibly already set. We wrap the definitions into
# a case switch that does nothing if the definition globs onto the
# current value. This is meant to avoid duplication in PATH.
eval "$(cat "$HOME"/.config/environment.d/* | grep -E '^[A-Za-z0-9_]*=' | while read -r line; do
  printf 'case "$%s" in\n(%s) ;;\n(*) export %s;;\nesac\n' \
    "${line%%=*}" \
    "$(printf "%s\n" "${line#*=}"|sed "s/\${${line%%=*}}/*/g")" \
    "$line"
done)"

test -n "$TMPDIR" && mkdir -p "${TMPDIR}"

has_cmd() {
  command -v "$1" >/dev/null 2>&1
}

has_cmd nano && export VISUAL=nano

# We are done for non-interactive logins
case "$-" in
  (*i*) ;;
  (*) return;;
esac

# If i log in on the linux tty, i usually want a GUI session
case "$TERM" in
(linux)
  if has_cmd niri; then
    niri
  elif has_cmd i3 && has_cmd xinit; then
    startx
  fi
esac
