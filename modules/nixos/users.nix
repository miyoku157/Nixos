# =============================================================================
# Users NixOS Module
# =============================================================================
# User account configuration.
#
# Creates the primary user account with:
#   - Normal user privileges (not system account)
#   - Sudo access (wheel group)
#   - NetworkManager access for managing connections
#
# Username is passed via specialArgs from flake.nix
# =============================================================================

{ config, pkgs, username, ... }:

{
  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
  };
}
