if status is-interactive
    # Commands to run in interactive sessions can go here
end

if status is-login
    set -x (gnome-keyring-daemon --start | string split "=")
end

set -gx MOZ_ENABLE_WAYLAND 1
set -g theme_nerd_fonts yes
set -g theme_color_scheme gruvbox
