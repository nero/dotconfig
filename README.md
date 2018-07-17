# Personal dotconfig

This repository is for synchronizing my shell and i3 settings across machines.
The checkout location is `$XDG_CONFIG_HOME`, which is usually equal to `$HOME/.config`.
`~/.profile` is made a symlink to the checkout location.
That also defines the value of `$XDG_CONFIG_HOME`.

The profile defines `$ENV`, which defines which file will by sourced by interactive shells.
Bash gives a shit about posix, thats why it needs to be manually instructed to call `$ENV` at the end of `profile`.
Bash also ignores `$ENV` in general and requires a `~/.bashrc` symlink to shellrc.
In addition to that, bash also calls the `~/.bashrc` for non-interactive shells under certain circumstances, thats why the shellrc tests for -i.

For xinit, a `~/.xinitrc` symlink needs to be created to point to `X/initrc`.
For tmux, the same needs to be done with `tmux.conf`.

## Goals

- Quick setup on new machines
- Portable across bourne-like shells
- Portable between terminal emulators
- Consistent DE behavior across machines
- Informative, but short prompt

## Environment variable conventions

- USER and HOME:
  Are a requirement. If not set, `profile` will guess.
- ENV:
  Path to the rc file for interactive shells
- XDG_CONFIG_HOME:
  Points to the checkout location of this repository.
  The `profile` detects this by following the `~/.profile` symlink if not present.
- HOSTNAME:
  Machine hostname, used to make give sockets per-machine names.
  Necessary when the homedir is shared across machines.

## Per-machine overrides

Machine-specific fixes are placed in `local/profile` and `local/shellrc`.
These files are optional.
