# Work PC specific configuration
# Only contains differences from base configuration
{ config, pkgs, inputs, hostname, userConfig, ... }:

{
  imports = [
    ./hardware.nix
    ../../modules/core
    ../../modules/desktops/plasma.nix
    ../../modules/nix-fast.nix
  ];

  # Hostname
  networking.hostName = userConfig.hostnames.work;

  # No wireless or bluetooth on desktop work PC
  # (base config doesn't enable these by default)

  # No LUKS encryption on work desktop
  # (add here if work PC gets encrypted later)

  # Fix USB autosuspend issue with printers
  # Prevents printers from appearing disconnected during USB power management
  boot.kernelParams = [ "usbcore.autosuspend=-1" ];

  # Allow printer service to fail gracefully if printers are offline
  systemd.services.ensure-printers = {
    serviceConfig = {
      Restart = "no";
      SuccessExitStatus = "0 1";
    };
  };

  # Work-specific printers: Canon G1430, Zebra ZD220, and Epson L1455
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
      {
        name = "Zebra_ZD220";
        location = "Office";
        deviceUri = "usb://Zebra%20Technologies/ZTC%20ZD220-203dpi%20ZPL?serial=D4J205103283";
        model = "drv:///sample.drv/zebra.ppd";  # Zebra ZPL Label Printer
        ppdOptions = {
          PageSize = "Custom.39.99x29.99mm";  # 40x30mm labels (actual: 39.99x29.99mm)
        };
      }
      {
        name = "Epson_L1455";
        location = "Office";
        deviceUri = "ipp://192.168.2.48:631/ipp/print";
        model = "epson-inkjet-printer-escpr/Epson-L1455_Series-epson-escpr-en.ppd";
        ppdOptions = {
          PageSize = "A4";
          MediaType = "PLAIN_NORMAL";  # Default quality: Normal (was Draft)
        };
      }
      {
        name = "Samsung_X4300LX";
        location = "Office";
        deviceUri = "ipp://192.168.2.115/ipp/printer";
        model = "everywhere";
        ppdOptions = {
          PageSize = "A4";
          MediaType = "PLAIN_NORMAL";
        };
      }
    ];
    ensureDefaultPrinter = "Canon_G1430";
  };
}
