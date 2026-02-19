{ config, lib, pkgs, ... }:

{
  # Enable printing support
  services.printing = {
    enable = true;
    browsing = true;  # Discover shared printers from other systems
    drivers = with pkgs; [
      splix
      gutenprint
      cnijfilter2  # Canon PIXMA drivers
      epson-escpr   # Epson ESC/P-R driver for older Epson printers
      epson-escpr2  # Epson ESC/P-R driver for newer Epson printers (EcoTank, WorkForce, etc)
    ];
  };
  
  # Enable network printer discovery and scanner support
  services.avahi = {
    enable = true;
    nssmdns4 = true;  # Resolve .local domains (mdns)
    openFirewall = true;
  };
  
  # Enable scanner support (SANE)
  hardware.sane = {
    enable = true;
    extraBackends = [ pkgs.sane-airscan ];  # For network scanners (AirScan/eSCL)
  };
}
