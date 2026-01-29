# Work PC specific configuration
# Only contains differences from base configuration
{ config, pkgs, inputs, hostname, userConfig, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/base
    ../../modules/nix-fast.nix
  ];

  # Hostname
  networking.hostName = userConfig.hostnames.work;

  # No wireless or bluetooth on desktop work PC
  # (base config doesn't enable these by default)

  # No LUKS encryption on work desktop
  # (add here if work PC gets encrypted later)

  # Work-specific printer: Canon G1430
  hardware.printers = {
    ensurePrinters = [
      {
        name = "Canon_G1430";
        location = "Office";
        deviceUri = "usb://Canon/G1030%20series?serial=000EF3";
        model = "canong1030.ppd";
        ppdOptions = {
          MediaType = "plain";  # Default: plain paper
          PageSize = "A4";
        };
      }
    ];
    ensureDefaultPrinter = "Canon_G1430";
  };
}
