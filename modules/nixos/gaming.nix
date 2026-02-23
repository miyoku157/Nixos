# =============================================================================
# Gaming NixOS Module
# =============================================================================
# Gaming-focused system configuration.
#
# Configures:
#   - Steam with gamescope session
#   - AMD GPU optimizations
#   - OpenGL with 32-bit support for games
#   - GameMode for performance optimization
#   - Gaming utilities (mangohud, lutris, heroic, etc.)
#   - Performance kernel tweaks
# =============================================================================

{ config, pkgs, ... }:

{
  # ===== Steam Configuration =====
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    gamescopeSession.enable = true;
  };

  # ===== AMD GPU Configuration =====
  services.xserver.videoDrivers = [ "amdgpu" ];
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # ===== GameMode Configuration =====
  programs.gamemode = {
    enable = true;
    settings = {
      general = {
        renice = 10;
      };
      gpu = {
        apply_gpu_optimisations = "accept-responsibility";
        gpu_device = 0;
        amd_performance_level = "high";
      };
    };
  };

  # ===== Gaming Packages =====
  environment.systemPackages = with pkgs; [
    # Performance tools
    gamemode
    gamescope
    mangohud
    
    # Game launchers
    lutris
    heroic
    bottles
    
    # Wine and compatibility
    wine-staging
    winetricks
    protonup-qt
    
    # Utilities
    (pkgs.discord.override {
      withOpenASAR = true;
      withVencord = true;
    })
  ];

  # ===== Performance Tweaks =====
  boot.kernel.sysctl = {
    "vm.max_map_count" = 16777216;  # Required for some games
  };
}
