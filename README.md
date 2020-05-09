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

## Xorg sessions

Depending on the setup, i either create `.xinitrc` as a symlink to `.config/xinitrc`, or create a custom `.xsession` file.
`xsession` implements whatever is necessary to load my environment and chains to `xinitrc`.

`xinitrc` does alot of things:

- apply monitor configuration as saved by arandr
- load xresources from the repo
- set keyboard layout + xmodmap fixes
- fill background with pixel lattice
- start i3 or fall back to xfce or plain terminal emulator

The i3 setup shows o spaces and no window decorations.
All windows are maximized, a single row on top of the screen displays the window titles in a browser-like tabbed fashion.

Most of my activity happens in a rxvt-unicode terminal, but depending on the setup, i might use other emulators as well.

## IRC

I use mosh or plain ssh to connect to the machine which is hosting irssi in a tmux session.
Notifications happen via the terminal bell, which propagates from irssi up to my window manager and causes the terminal title to turn to a bright color.

## Clicking links

rxvt is configured to hilight links with a underscore and run `xdg-open` on them.
`xdg-open` is a script from the repo in this case.
The name was intentionally chosen to override the systems default handler with the same name.

`xdg-open` runs the `view` script in a new terminal window / tmux pane.
`view` itself contains complex logic to display the contents of the url to me, usually via feh, mpv or by chaining to firefox.
This includes displaying files of unknown type via hexdump, or showing text files via `less`.
It also degrades nicely in functionality when there is no Xorg available.

## Saving memes

There is the `save` command, which is a wrapper around `wget`.
Its job is to generate a useful filename and extension for the download.
The downloaded files end up directly in my home directory, where they are later archived from.

## Archiving

My homedir and Downloads folder has a constant influx of memes, datasheet PDFs and compressed archives.
To avoid them piling up, i occasionally run the `archive` script to move them into `~/archive/$YEAR/$MONTH`.
This cleans all non-hidden files that are directly in ~/$HOME.
For directories, i need to explicitly call `archive` on them.

## Backup

There is a `do-backup` script which does a rsync of `$HOME` to a storage machine.
It uses a long ignore list from `.config/nobackup.txt` to avoid caches, sensitive data and trash.
The destination directory is host specific with delete propagation.
This means when i delete a file locally, it is also deleted from the backup on the next `do-backup` run.

The archive directory special: it is backupped to a directory shared for all machines, files from there are never deleted.
This is my `data dump` that i go digging in when im looking for things from earlier times.
