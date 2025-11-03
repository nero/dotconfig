# .profile for POSIX-conformant shells

old_ssh_auth_sock=$SSH_AUTH_SOCK

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

# Test if there is an ssh-agent behind a socket
test_ssh_agent() {
  SSH_AUTH_SOCK="${1:?Needs socket path as argument}" ssh-add -L >/dev/null 2>&1
  # 0=said yes, 1=said no, 2=couldnt talk, 127=command not found
  test $? -lt 2
}

if test -n "$SSH_AUTH_SOCK" && ! test_ssh_agent "$SSH_AUTH_SOCK"; then
  rm -f "$SSH_AUTH_SOCK"
  if test -z "$old_ssh_auth_sock" || ! test_ssh_agent "$old_ssh_auth_sock"; then
    eval "$(ssh-agent -a "$SSH_AUTH_SOCK")"
  else
    ln -s "$old_ssh_auth_sock" "$SSH_AUTH_SOCK"
  fi
fi

unset old_ssh_auth_sock

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

# If i log in on the linux tty, i usually want a GUI session
case "$TERM" in
(linux)
  if has_cmd niri; then
    niri
  elif has_cmd i3 && has_cmd xinit; then
    startx
  fi
esac
