function sway-run
  set -gx MOZ_ENABLE_WAYLAND 1
  set -gx QT_QPA_PLATFORM wayland-egl
  set -gx QT_WAYLAND_FORCE_DPI physical
  set -gx ECORE_EVAS_ENGINE wayland_egl
  set -gx ELM_ENGINE wayland_egl
  set -gx SDL_VIDEODRIVER wayland
  set -gx XDG_CURRENT_DESKTOP sway
  set -gx WLR_NO_HARDWARE_CURSORS 1
  sway --unsupported-gpu
end
