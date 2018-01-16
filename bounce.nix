# bounce.nix
{
  bounce =
  { config, lib, pkgs, ... }:
  {
    boot.kernelParams = [ "console=ttyS0,19200n8" ];
    boot.loader.grub.extraConfig = ''
      serial --speed=19200 --unit=0 --word=9 --parity=no --stop=1;
      terminal_input serial;
      terminal_output serial
    '';
    boot.loader.grub.device = "nodev";
    boot.loader.timeout = 10;

    services.openssh = {
      enable = true;
      permitRootLogin = "yes";
    };

    networking.usePredictableInterfaceNames = false;

    # Use the GRUB 2 boot loader.
    boot.loader.grub.enable = true;
    boot.loader.grub.version = 2;

    system.stateVersion = "17.09"; # Did you read the comment?

    deployment.targetHost = "74.207.236.197";
    imports =
      [ <nixpkgs/nixos/modules/profiles/qemu-guest.nix>
    ];

    boot.initrd.availableKernelModules = [ "ata_piix" "virtio_pci" "floppy" "sd_mod" ];
    boot.kernelModules = [ ];
    boot.extraModulePackages = [ ];

    fileSystems."/" =
    { device = "/dev/sda";
      fsType = "ext4";
    };

    swapDevices =
      [ { device = "/swapfile"; }
    ];
    environment.systemPackages = with pkgs; [
      bash
      tinc
      screen
    ];

    nix.maxJobs = lib.mkDefault 1;
  };
}
