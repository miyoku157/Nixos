# =============================================================================
# Default Overlay
# =============================================================================
# Adds custom packages to nixpkgs.
#
# This overlay:
#   - Adds the hyprdots package to pkgs, making it available as pkgs.hyprdots
#   - The package is defined in packages/hyprdots.nix
#
# Overlays modify the package set globally, so hyprdots is available in:
#   - System packages (environment.systemPackages)
#   - Home packages (home.packages)
#   - Any other context that uses pkgs
# =============================================================================

self: super: {
  hyprdots = self.callPackage ../packages/hyprdots.nix { };
}
