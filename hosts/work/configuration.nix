# Work PC specific configuration
# Only contains differences from base configuration
{ config, pkgs, inputs, hostname, userConfig, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/base
  ];

  # Hostname
  networking.hostName = userConfig.hostnames.work;

  # No wireless or bluetooth on desktop work PC
  # (base config doesn't enable these by default)

  # No LUKS encryption on work desktop
  # (add here if work PC gets encrypted later)
}
