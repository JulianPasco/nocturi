# Home PC specific configuration
# Only contains differences from base configuration
{ config, pkgs, inputs, hostname, userConfig, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/base
    ../../modules/nix-fast.nix
  ];

  # Hostname
  networking.hostName = userConfig.hostnames.home;

  # LUKS encryption (home laptop specific)
  boot.initrd.luks.devices."luks-794928c8-0140-44c3-8efe-88c3625a4b07".device = 
    "/dev/disk/by-uuid/794928c8-0140-44c3-8efe-88c3625a4b07";

  # Enable wireless and bluetooth (laptop features)
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # Add laptop-specific package (battery management)
  environment.systemPackages = with pkgs; [
    upower  # Required for battery detection
  ];
}
