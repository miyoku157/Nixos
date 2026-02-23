# =============================================================================
# Hardware Configuration - miyoku157
# =============================================================================
# Auto-generated hardware configuration. Customize with your actual hardware.
#
# TODO: Replace UUIDs and hardware modules with your system's values
# Run `lsblk -f` to find your partition UUIDs
# Run `lscpu | grep Vendor` to check CPU type (Intel/AMD)
# =============================================================================

{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # Kernel modules for initial ramdisk (customize based on your hardware)
  boot.initrd.availableKernelModules = [ 
    "xhci_pci"      # USB 3.0
    "ahci"          # SATA
    "nvme"          # NVMe SSD
    "usb_storage"   # USB storage
    "sd_mod"        # SD card
  ];
  
  boot.initrd.kernelModules = [ ];
  
  # Change to "kvm-amd" if you have an AMD CPU
  boot.kernelModules = [ "kvm-intel" ];
  
  boot.extraModulePackages = [ ];

  # Boot loader configuration
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # File Systems
  # TODO: Replace UUIDs with your actual partition UUIDs (use `lsblk -f`)
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/XXXX-XXXX";
    fsType = "vfat";
  };

  # Swap configuration (uncomment and set UUID if you have swap)
  # swapDevices = [ 
  #   { device = "/dev/disk/by-uuid/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"; }
  # ];

  # CPU microcode updates
  # Change to hardware.cpu.amd.updateMicrocode for AMD CPUs
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # Networking hardware
  networking.useDHCP = lib.mkDefault true;

  # System architecture
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
