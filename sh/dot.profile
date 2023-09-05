# .profile for POSIX-conformant shells

: ${LOGNAME:=$(id -un)}
: ${LANG:=en_US.UTF-8}
: ${ENV:=$HOME/.config/sh/rc}

for f in ${HOME:?}/.config ${HOME:?}/.local; do
  PATH=${f}/bin:${PATH}
  MANPATH=${f}/share/man:${MANPATH}
done

export LOGNAME LANG ENV PATH MANPATH

# load drop-ins
for f in "$HOME"/.config/*/profile; do
  c=${f%/*}
  command -v "${c##*/}" >/dev/null 2>&1 && . "$f"
done
unset c f

# launch more complex session types if shell is interactive
# this only happens once at SSH or getty login
case "$-" in
  (*i*) (for i in "$HOME"/.config/session/*; do . $i; done);;
esac
