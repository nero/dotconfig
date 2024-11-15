# .profile for POSIX-conformant shells

: ${LOGNAME:=$(id -un)}
: ${LANG:=en_US.UTF-8}
: ${ENV:=$HOME/.config/sh/rc}

mkdir -p "${HOME:?}/.local/tmp"
TMPDIR=${HOME:?}/.local/tmp
PATH=${HOME:?}/.local/bin:${HOME:?}/.config/bin:${PATH:?}
MANPATH=${HOME:?}/.local/share/man:${HOME:?}/.config/share/man:${MANPATH}

export LOGNAME LANG ENV TMPDIR PATH MANPATH

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
if has_cmd i3 && test -z "$DISPLAY" && has_cmd xinit && test -z "$SSH_CONNECTION"; then
  startx
fi
