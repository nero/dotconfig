# .profile for POSIX-conformant shells

# This is for really crappy environments
: ${LOGNAME:=$(id -un)}
: ${HOME:=~}

# Systems without locales dont set it while some programs require it
: ${LANG:=en_US.UTF-8}

# Path to config for interactive shells
: ${ENV:=$HOME/.config/env}

PATH=$HOME/.local/bin:$HOME/.config/bin:$PATH

export LOGNAME HOME LANG ENV PATH

# load drop-ins
for f in "$HOME"/.config/*/profile; do
  c=${f%/*}
  command -v "${c##*/}" >/dev/null 2>&1 && . "$f"
done
unset c f

# When bash is started as interactive login shell, it sources the profile
# like any other shell and then fails to load its own bashrc.
[ -n "$BASH_VERSION" ] && . "$ENV"
