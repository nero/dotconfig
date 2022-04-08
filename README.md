# Personal dotconfig

This repository is for synchronizing my shell and i3 settings across machines.
The checkout location is `$XDG_CONFIG_HOME`, which is usually equal to `$HOME/.config`.
The `env` file is used as environment for interactive shells.

For xinit, a `~/.xinitrc` symlink needs to be created to point to `xinitrc`.
For tmux, the same needs to be done with `tmux.conf`.
There is an `install` script in the root of this project to set up these symlinks automatically.

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

Machine-specific fixes are placed in `env.d/` or `profile.d/`.

## Use in shell scripts

Shell scripts started from background daemons like cron or init won't have the environment variables resulting from the login process and `profile`.
Appending `-l` to the end of their shebang line will cause the executing shell to undergo this process and, in turn, also load the settings from `profile`.

## Xorg sessions

Depending on the setup, i either create `.xinitrc` as a symlink to `.config/xinitrc`, or create a custom `.xsession` file.
`xsession` implements whatever is necessary to load my environment and chains to `xinitrc`.

`xinitrc` does alot of things:

- load xresources
- set keyboard layout + xmodmap fixes
- start a sample terminal window to guess an appropiate font size
- fill background with a pixel lattice
- start i3 or fall back to xfce or plain terminal emulator

The i3 setup shows no spaces and no window decorations.
All windows are maximized, a single row on top of the screen displays the window titles in a browser-like tabbed fashion.

Most of my activity happens in xterm, but depending on the setup, i might use other emulators as well.

## Opening links

I select links with the mouse curser and use a keyboard shortcut to feed them into `xdg-open`.
`xdg-open` is a script from the repo.
The name was intentionally chosen to override the systems default handler with the same name.

`xdg-open` runs the `view` script in a new terminal window / tmux pane.
`view` itself contains complex logic to display the contents of the url to me, usually via feh, mpv or by chaining to firefox.
This includes displaying files of unknown type via hexdump, or showing text files via `less`.
It also degrades nicely in functionality when there is no Xorg available.
