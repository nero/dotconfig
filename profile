# .profile for POSIX-conformant shells

# This is for really crappy environments
: ${LOGNAME:=$(id -un)}
: ${HOME:=~}

# Systems without locales dont set it while some programs require it
: ${LANG:=en_US.UTF-8}

# Path to config for interactive shells
: ${ENV:=${XDG_CONFIG_HOME:-$HOME/.config}/env}

# Directory for sockets and pid files
: ${XDG_RUNTIME_DIR:=$(
  for i in "/run/user/$(id -u)" "$HOME/.local/run/$(uname -n)" "/tmp/${LOGNAME}-run"; do
    mkdir -m 0700 -p "$i" 2>/dev/null \
      && test -w "$i" \
      && printf "%s\n" "$i" \
      && break
  done
)}

PATH=${HOME}/.local/bin:${XDG_CONFIG_HOME:-$HOME/.config}/bin:$PATH

export LOGNAME HOME LANG ENV XDG_RUNTIME_DIR PATH

# load drop-ins
for f in "${XDG_CONFIG_HOME:-$HOME/.config}"/*/profile; do
  c=${f%/*}
  command -v "${c##*/}" >/dev/null 2>&1 && . "$f"
done
unset c f

# When bash is started as interactive login shell, it sources the profile
# like any other shell and then fails to load its own bashrc.
[ -n "$BASH_VERSION" ] && . "$ENV"
