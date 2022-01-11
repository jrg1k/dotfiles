if status is-interactive
    # Commands to run in interactive sessions can go here
end

if status is-login
    set -gx BW_SESSION "1rkp0JdLtn5V4xQpV2N8gENpcmzeMkVKQTX2u1UKiLS3rK1w9x/aAQ8jL8pv6d9v+88/Bub7yZ1Z73yTya9IFg=="
end

if test -n "$DESKTOP_SESSION"
    set -x (gnome-keyring-daemon --start | string split "=")
end
