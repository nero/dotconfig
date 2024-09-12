# Personal dotconfig

This repository is for synchronizing my `~/.config` directory across machines.
It does not use any dotfile manager, its only that directory tracked in git.
There is an `./install` script that sets up some symlinks.

## Shells launched in the background

Shell scripts started from background daemons like cron or init won't have the environment variables resulting from the login process and `profile`.
Appending `-l` to the end of their shebang line will cause the executing shell to undergo this process and, in turn, also load these settings.

## i3

In i3 sessions, all windows run maximized with a tabbed layout.
Windows are switched by using the left Windows Key and WASD, moved by additionally holding shift.
A new terminal is launched using Windows+Enter.
