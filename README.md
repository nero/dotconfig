# Personal dotconfig

This repository is for synchronizing my `~/.config` directory across machines.

It does not use any dotfile manager, its only that directory tracked in git.

There is an `./install` script that sets up some symlinks.

Supported shells are `dash`, `mksh`, `bash` and `zsh`.

## Topical directories

Most directories in this repo are related to some specific software.
I call these 'topical directory'.
Each topical directory can have a selection of three snippets:

- `install`, sourced during dotfiles installation
- `profile` for login shells
- `env` for interactive shells

Each is called by the respective script in the repo root, if and only if a command with the same name of the topical directory exists.
This is the mechamism to only select configuration of software that is installed on the specfic system.

## Shells launched in the background

Shell scripts started from background daemons like cron or init won't have the environment variables resulting from the login process and `profile`.
Appending `-l` to the end of their shebang line will cause the executing shell to undergo this process and, in turn, also load these settings.

## Xorg / i3 / xterm

Somehow the `xinitrc` must be started, this integration depends on whether you use a display manager or startx.
When run, it does the usual Xorg configuration including Xmodmap and Xresources.

The setup is simple.
All windows run maximized, only one bar at the top displays the titles of all windows.
Windows are switched between by using the left Alt-Key and WASD, moved by additionally holding shift.
A new terminal is launched using Alt+Enter.

xterm is configured via Xresources.
If xterm is not installed, rxvt-unicode is tried.

## Wayland / Sway / foot

Sway can be started from the tty. Both `sway` and `foot` look into `~/.config` on their own.

Sway is using the same config as i3.

## xdg-open

This repo ships an own `xdg-open` overriding the system one.
It runs the `view` script in a new terminal window.
`view` itself contains complex logic to display the contents of the url to me, usually via feh, mpv or by chaining to firefox.
This includes displaying files of unknown type via hexdump, or showing text files via `less`.
It also degrades nicely in functionality when there is no Xorg or Wayland available, by resorting to command line programs.
