{ config, lib, pkgs, ... }:

{
  # Enable printing support
  services.printing = {
    enable = true;
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
    nssmdns4 = true;
    openFirewall = true;
  };
  
  # Enable scanner support (SANE)
  hardware.sane = {
    enable = true;
    extraBackends = [ pkgs.sane-airscan ];  # For network scanners (AirScan/eSCL)
  };
}
