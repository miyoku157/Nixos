{
  description = "Rivendell - Modular Hyprland NixOS Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";

    hyprdots = {
      url = "git+https://codeberg.org/miyoku157/rivendell-hyprdots.git";
      flake = false;
    };

  };

  outputs = inputs@{ self, nixpkgs, home-manager, hyprland, ... }:
  let
    systems = [ "x86_64-linux" "aarch64-linux" ];

    # Helper for per-system pkgs
    forAllSystems = f:
      nixpkgs.lib.genAttrs systems
        (system:
          f (import nixpkgs {
            inherit system;
            overlays = [
              (final: prev: { hyprdots-input = inputs.hyprdots; })
              self.overlays.default
            ];
            config.allowUnfree = true;
          })
        );
  in
  {

    # ===============================
    # Per-system outputs
    # ===============================

    packages = forAllSystems (pkgs: {
      hyprdots = pkgs.callPackage ./packages/hyprdots.nix { };
    });

    devShells = forAllSystems (pkgs: {
      default = pkgs.mkShell {
        buildInputs = with pkgs; [
          nixpkgs-fmt
          git
        ];
      };
    });

    formatter = forAllSystems (pkgs: pkgs.nixpkgs-fmt);


    # ===============================
    # Global outputs
    # ===============================

    overlays.default = import ./overlays;

    nixosModules = {
      core      = import ./modules/nixos/core.nix;
      hyprland  = import ./modules/nixos/hyprland.nix;
      users     = import ./modules/nixos/users.nix;
      gaming    = import ./modules/nixos/gaming.nix;
    };

    homeModules = {
      core      = import ./modules/home/core.nix;
      hyprdots  = import ./modules/home/hyprdots.nix;
    };

    lib.mkHost = import ./lib/mkHost.nix (inputs // { inherit self; });


    # ===============================
    # Host definitions
    # ===============================

    nixosConfigurations = {
      miyoku157 = self.lib.mkHost {
        hostname = "miyoku157";   # MUST match `hostname`
        system   = "x86_64-linux";
        username = "miyoku157";
      };
    };
  };
}
