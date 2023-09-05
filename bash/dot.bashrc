# Bash being braindead no 2:
# Non-interactive bash launched via SSH sources the wrong config file
# Do not load the config for interactive shells if not interactive
case "$-" in
  (*i*) . "$ENV";;
  (*) return;;
esac
