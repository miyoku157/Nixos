# =============================================================================
# Hyprdots Home Module
# =============================================================================
# User-level dotfiles management for Hyprland configuration.
#
# This module:
#   1. Sources the hyprdots package (defined in packages/hyprdots.nix)
#   2. Symlinks dotfiles from the package to appropriate XDG locations:
#      - Hyprland config -> ~/.config/hypr/
#      - Waybar config -> ~/.config/waybar/
#      - Rofi config -> ~/.config/rofi/
#      - Dunst config -> ~/.config/dunst/
#      - Zsh configs -> ~/.zshrc and ~/.zprofile
#
# Dotfiles are managed as a Nix package, ensuring reproducibility.
# =============================================================================

{ pkgs, hyprdots, ... }:

let
  dotfiles = hyprdots;
in
{
  xdg.configFile."hypr".source = "${dotfiles}/hypr";
  xdg.configFile."waybar".source = "${dotfiles}/waybar";
  xdg.configFile."rofi".source = "${dotfiles}/rofi";
  xdg.configFile."dunst".source = "${dotfiles}/dunst";

  home.file.".zshrc".source = "${dotfiles}/.zshrc";
  home.file.".zprofile".source = "${dotfiles}/.zprofile";
}
