# =============================================================================
# Core NixOS Module
# =============================================================================
# System-wide base configuration applied to all hosts.
#
# Configures:
#   - Hostname (passed via specialArgs)
#   - Timezone and locale
#   - NetworkManager for network connectivity
#   - Essential system packages (git, curl, wget)
#   - NixOS state version for compatibility
# =============================================================================

{ config, pkgs, hostname, ... }:

{
  networking.hostName = hostname;

  # French locale and timezone
  time.timeZone = "Europe/Paris";

  i18n.defaultLocale = "fr_FR.UTF-8";

  # AZERTY keyboard layout
  console.keyMap = "fr";

  # Keyboard layout for X11/Wayland (applies to Hyprland)
  services.xserver.xkb = {
    layout = "fr";
    variant = "";
  };

  services.networkmanager.enable = true;

  environment.systemPackages = with pkgs; [
    git
    curl
    wget
  ];

  system.stateVersion = "25.11";
}
