# =============================================================================
# mkHost - Host Configuration Builder
# =============================================================================
# This function creates a NixOS system configuration for a specific host.
#
# Parameters:
#   hostname - The name of the host (must match a directory in ../hosts/)
#   system   - The system architecture (e.g., "x86_64-linux", "aarch64-linux")
#   username - The primary user's username for home-manager configuration
#
# The function:
#   1. Imports host-specific hardware/config from hosts/${hostname}/
#   2. Applies NixOS modules (core, hyprland, users)
#   3. Configures home-manager for the specified user
#   4. Passes special arguments (inputs, username, hostname) to all modules
# =============================================================================

{ self, nixpkgs, home-manager, ... }@inputs:

{ hostname, system, username }:

nixpkgs.lib.nixosSystem {
  inherit system;

  # specialArgs makes these values available to all modules
  # This allows modules to access flake inputs and configuration parameters
  specialArgs = {
    inherit inputs username hostname;
  };

  # Module loading order:
  # 1. Host-specific configuration (hardware, machine-specific settings)
  # 2. NixOS modules (system-wide configuration)
  # 3. Home-manager integration (user-level configuration)
  modules = [
    ../hosts/${hostname}

    self.nixosModules.core
    self.nixosModules.hyprland
    self.nixosModules.users
    self.nixosModules.gaming

    home-manager.nixosModules.home-manager

    # Home-manager configuration as a NixOS module
    # This integrates user-level dotfiles and packages into the system config
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;

      home-manager.users.${username} = {
        imports = [
          self.homeModules.core
          self.homeModules.hyprdots
        ];
      };
    }
  ];
}
