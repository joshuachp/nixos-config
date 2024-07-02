##
# Key binds
#
fish_vi_key_bindings

##
# Env
#
set -x GPG_TTY (tty)
set -x SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)

##
# Theme
#
set fish_color_command green

# Fish configuration
set fish_greeting
