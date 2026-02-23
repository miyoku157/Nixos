# =============================================================================
# Hyprdots Package
# =============================================================================
# Packages the dotfiles from git repository as a Nix derivation.
#
# This package:
#   - Fetches from Codeberg repository
#   - Strips the home/ prefix from the source structure
#   - Copies dotfiles to the Nix store
#   - Makes dotfiles available as an immutable package
#
# The dotfiles can then be symlinked into user directories via home-manager
# (see modules/home/hyprdots.nix for usage).
#
# Benefits:
#   - Dotfiles are versioned with your system configuration
#   - Atomic updates with system rebuilds
#   - Easy rollback to previous dotfile versions
#
# Note: On first build, replace the placeholder hash with the actual hash
# from the error message.
# =============================================================================

{ stdenv, dotfiles-src }:

stdenv.mkDerivation {
  pname = "rivendell-hyprdots";
  version = "1.0.0";

  src = dotfiles-src;

  installPhase = ''
    mkdir -p $out
    
    # Copy config files directly from repository root
    if [ -d .config ]; then
      cp -r .config/* $out/
    fi
    
    # Copy shell configuration files
    if [ -f .zshrc ]; then
      cp .zshrc $out/.zshrc
    fi
    if [ -f .zprofile ]; then
      cp .zprofile $out/.zprofile
    fi
    
    # Copy assets if they exist
    if [ -d assets ]; then
      cp -r assets $out/assets
    fi
  '';
}
