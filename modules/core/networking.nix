{ config, lib, pkgs, ... }:

{
  # Networking (hostname set per-host)
  networking.networkmanager = {
    enable = true;
    dns = "systemd-resolved";  # Hand DNS off to resolved for caching + Tailscale
  };
  systemd.services.NetworkManager-wait-online.enable = false;

  # systemd-resolved: DNS caching, DNSSEC, proper Tailscale split-DNS
  services.resolved = {
    enable = true;
    settings.Resolve = {
      DNSSEC      = "allow-downgrade";   # Validate where supported, fallback where not
      Domains     = [ "~." ];            # Route all domains through resolved
      FallbackDNS = [ "1.1.1.1" "9.9.9.9" ];
    };
  };

  # Enable Tailscale VPN
  services.tailscale.enable = true;
  networking.firewall.checkReversePath = "loose";  # Fix routing for Tailscale exit nodes/subnets
}
