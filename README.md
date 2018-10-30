# Personal dotconfig

This repository is for synchronizing my shell and i3 settings across machines.
The checkout location is `$XDG_CONFIG_HOME`, which is usually equal to `$HOME/.config`.
`~/.profile` is made a symlink to the checkout location.
That also defines the value of `$XDG_CONFIG_HOME`.

The profile defines `$ENV`, which defines which file will by sourced by interactive shells.
Bash ignores `$ENV` in general and requires a `~/.bashrc` symlink to shellrc.
In addition to that, bash also calls the `~/.bashrc` for non-interactive shells under certain circumstances, thats why the shellrc tests for -i.

For xinit, a `~/.xinitrc` symlink needs to be created to point to `X/initrc`.
For tmux, the same needs to be done with `tmux.conf`.

## Goals

- Quick setup on new machines
- Portable across bourne-like shells
- Portable between terminal emulators
- Consistent DE behavior across machines
- Informative, but short prompt

## Environment variable made available

- USER
- HOME
- HOSTNAME
- XDG_CONFIG_HOME:
  Points to the checkout location of this repository.
  The `profile` detects this by following the `~/.profile` symlink if not present.
- XDG_RUNTIME_DIR:
  Location for sockets, fifo's and pid files.
- ENV:
  Location of the rc file for interactive POSIX shells.

## Per-machine overrides

Machine-specific fixes are placed in `profile.d/` and `shellrc.d/`.
These directories are optional.

## Use in shell scripts

Shell scripts started from background daemons like cron or init won't have the environment variables resulting from the login process and `profile`.
Appending `-l` to the end of their shebang line will cause the executing shell to undergo this process and, in turn, also load the settings from `profile`.
