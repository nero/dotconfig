# Bash being braindead:
# Non-interactive bash launched via SSH sources the wrong config file
# Do not load the config for interactive shells if not interactive
case "$-" in
  (*i*) ;;
  (*) return;;
esac

test -n "$ENV" && . "$ENV"

PS1='\[\033[1;32m\]\u@\h\[\033[0m\]:\[\033[1;34m\]\w\[\033[0m\]\$ '

for f in "$HOME"/.config/bashrc.d/*; do
  . "$f"
done
unset f
