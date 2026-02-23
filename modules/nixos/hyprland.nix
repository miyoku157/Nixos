# =============================================================================
# Hyprland NixOS Module
# =============================================================================
# System-wide Hyprland window manager configuration.
#
# Configures:
#   - X server (required for some compatibility)
#   - Hyprland from the flake input (latest version)
#   - Essential Wayland utilities (waybar, rofi, dunst, etc.)
#   - Screenshot tools (grim, slurp)
#   - Media controls (playerctl)
# =============================================================================

{ config, pkgs, inputs, ... }:

{
  services.xserver.enable = true;

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  };

  environment.systemPackages = with pkgs; [
    waybar
    rofi-wayland
    dunst
    kitty
    wl-clipboard
    grim
    slurp
    swaybg
    playerctl
  ];
}
