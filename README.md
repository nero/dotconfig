# Personal dotconfig

This repository is for synchronizing my `~/.config` directory across machines.
It does not use any dotfile manager, its only that directory tracked in git.
There is an `./install` script that sets up some symlinks.

## Shells launched in the background

Shell scripts started from background daemons like cron or init won't have the environment variables resulting from the login process and `profile`.
Appending `-l` to the end of their shebang line will cause the executing shell to undergo this process and, in turn, also load these settings.

## Xorg / i3 / xterm

When launching from a tty, the ´bin/x´ script is used, replacing ´startx´ as wrapper to ´xinit´.
Xresources and keyboard setup are done by the ´X/rc´ script, which can be re-sourced any time.
For sessions started with XRDP or any display manager, i write a custom xinitrc/xsessionrc, whatever is needed.
The ´x´ script takes the command for the main window program, which is usually xterm or i3.

With i3, all windows run maximized, only one bar at the top displays the titles of all windows.
Windows are switched by using the left Alt-Key and WASD, moved by additionally holding shift.
A new terminal is launched using Alt+Enter.
