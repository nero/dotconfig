# .profile for POSIX-conformant shells

: ${LOGNAME:=$(id -un)}
: ${LANG:=en_US.UTF-8}
: ${ENV:=$HOME/.config/sh/rc}

for f in ${HOME:?}/.config ${HOME:?}/.local; do
  PATH=${f}/bin:${PATH}
  MANPATH=${f}/share/man:${MANPATH}
done

export LOGNAME LANG ENV PATH MANPATH

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
if has_cmd i3 && test -z "$DISPLAY" && has_cmd xinit; then
  x i3
fi

# auto-attach to tmuxes
if has_cmd tmux && test -z "$TMUX" && test -n "$SSH_CONNECTION"; then
  tmux new -As0
fi
