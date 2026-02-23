# =============================================================================
# Core Home Module
# =============================================================================
# User-level base configuration via home-manager.
#
# Configures:
#   - Home directory and username (from specialArgs)
#   - Zsh shell
#   - Essential user packages:
#     - neovim: Text editor
#     - fastfetch: System information
#     - btop: System monitor
#     - eza: Modern ls replacement
#     - fzf: Fuzzy finder
#
# These packages are installed per-user, not system-wide.
# =============================================================================

{ pkgs, username, ... }:

{
  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "24.11";

  programs.zsh.enable = true;

  home.packages = with pkgs; [
    neovim
    fastfetch
    btop
    eza
    fzf
  ];
}
