# Personal dotconfig

This repository is for synchronizing my shell and i3 settings across machines.
The checkout location is `$XDG_CONFIG_HOME`, which is usually equal to `$HOME/.config`.

There is an `./install` script that sets up some symlinks.
For programs that look into `$XDG_CONFIG_HOME` on their own, no symlink is needed.

## POSIX-compatible shells

The `~/.profile` symlink serves as entry point during any login operation.
It is pointing to the `profile` file of this repo.
And login shell is supposed to source it.

The `env` file serves as config file for interactive shells.
Its function is to ensure a consistent setup across bourne shell variants.

It makes sure the following environment variables have sensible values:

- USER
- HOME
- HOSTNAME
- XDG_CONFIG_HOME:
  Points to the checkout location of this repository.
  The `profile` detects this by following the `~/.profile` symlink if not present.
- XDG_RUNTIME_DIR:
  Location for sockets, fifo's and pid files.
- ENV:
  Location of the env file for interactive shells.

The PATH variable is updated to contain the `bin` directory.

Bash and Zsh have own entrypoints, they are automatically set up as symlinks by the `./install` script if the respective shell is configured as login shell.

### Per-machine overrides

Machine-specific fixes can be placed in `env.d/` or `profile.d/`.

### Use in shell scripts

Shell scripts started from background daemons like cron or init won't have the environment variables resulting from the login process and `profile`.
Appending `-l` to the end of their shebang line will cause the executing shell to undergo this process and, in turn, also load the settings from `profile`.

## Xorg with startx

For this to work, a symlink `~/.xinitrc` pointing to the `xinitrc` file needs to be created.

`xinitrc` does alot of things:

- load xresources
- set keyboard layout + xmodmap fixes
- start a sample terminal window to guess an appropiate font size
- fill background with a pixel lattice
- start i3 or fall back to xfce or plain terminal emulator

## Xorg with Display Manager

This requires manual scripting.
A custom `~/.xsession` or `~/.xsessionrc` chains to `xinitrc`, possibly after sourcing the `profile` to load the environment variables.

## i3

i3 respects `$XDG_CONFIG_HOME` on its own and reads its config from `i3/config`.

The setup is simple.
All windows run maximized, only one bar at the top displays the titles of all windows.
Windows are switched between by using the left Alt-Key and WASD, moved by additionally holding shift.
A new terminal is launched using Alt+Enter.

## x-terminal-emulator

The repo overrides the system `x-terminal-emulator` with its own.
Depending on whats available, xterm or urxvt is launched, with a fallback to the system-wide script if none was found.
Both of these terminal emulators are configured with the same Xresources and are configured to behave similar.

## xdg-open

This repo ships an own `xdg-open` overriding the system one.
It runs the `view` script in a new terminal window / tmux pane.
`view` itself contains complex logic to display the contents of the url to me, usually via feh, mpv or by chaining to firefox.
This includes displaying files of unknown type via hexdump, or showing text files via `less`.
It also degrades nicely in functionality when there is no Xorg available, by resorting to command line programs.
