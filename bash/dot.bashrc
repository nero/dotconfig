# Bash being braindead:
# Non-interactive bash launched via SSH sources the wrong config file
# Do not load the config for interactive shells if not interactive
case "$-" in
  (*i*) ;;
  (*) return;;
esac

test -n "$ENV" && . "$ENV"
