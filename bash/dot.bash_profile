# Source the portable profile
. ~/.config/sh/dot.profile

# Bash being braindead no 1:
# Interactive login bash does neither load .bashrc or $ENV
# So source the config for interactive shells manually
case "$-" in
  (*i*) . "$ENV";;
  (*) ;;
esac
