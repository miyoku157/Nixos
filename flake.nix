{
  # =============================================================================
  # Rivendell - Modular Hyprland NixOS Flake
  # =============================================================================
  # This flake provides a modular NixOS configuration with Hyprland window manager.
  # 
  # Structure:
  #   - inputs: External dependencies (nixpkgs, home-manager, hyprland, etc.)
  #   - outputs: Exports packages, modules, overlays, and NixOS configurations
  #   - lib.mkHost: Helper function to create new host configurations easily
  #   - modules: Reusable NixOS and home-manager configuration modules
  #   - overlays: Custom package additions/modifications to nixpkgs
  # =============================================================================

  description = "Rivendell - Modular Hyprland NixOS Flake";

  # External flake inputs - pinned dependency sources
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";

    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, flake-utils, ... }:
    let
      lib = nixpkgs.lib;
      systems = [ "x86_64-linux" "aarch64-linux" ];
    in
    # Per-system outputs (packages, dev shells, formatters)
    # These are built for each architecture in the systems list
    flake-utils.lib.eachSystem systems (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ self.overlays.default ];
          config.allowUnfree = true;
        };
      in
      {
        packages.hyprdots = pkgs.callPackage ./packages/hyprdots.nix { };

        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            nixpkgs-fmt
            git
          ];
        };

        formatter = pkgs.nixpkgs-fmt;
      }
    ) // {
      # Flake-wide outputs (not system-specific)
      # Overlays modify/extend nixpkgs, modules provide reusable config

      overlays.default = import ./overlays;

      nixosModules = {
        core = import ./modules/nixos/core.nix;
        hyprland = import ./modules/nixos/hyprland.nix;
        users = import ./modules/nixos/users.nix;
        gaming = import ./modules/nixos/gaming.nix;
      };

      homeModules = {
        core = import ./modules/home/core.nix;
        hyprdots = import ./modules/home/hyprdots.nix;
      };

      lib.mkHost = import ./lib/mkHost.nix;

      # Host configurations - define your machines here
      nixosConfigurations = {
        rivendell =
          self.lib.mkHost {
            hostname = "rivendell";
            system = "x86_64-linux";
            username = "miyoku157";
          };
      };
    };
}
