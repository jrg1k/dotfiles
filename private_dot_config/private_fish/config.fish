if status is-interactive
    # Commands to run in interactive sessions can go here
end

if test -n "$DESKTOP_SESSION"
    set -gx MOZ_ENABLE_WAYLAND 1
    set -gx QT_QPA_PLATFORM wayland
    set -gx SDL_VIDEODRIVER wayland
end

set -g theme_nerd_fonts yes
set -g theme_color_scheme gruvbox
