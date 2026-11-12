{ config, pkgs, lib, ... }:
{
  imports = [
    ./entrypoint.nix
    # ./stirling-pdf.nix
  ];

  services.siteMonitor.enable = true;
  services.stirling-pdf.enable = true;
  services.tailscale.permitCertUid = "caddy";

  services.caddy = {
    enable = true;
    globalConfig = ''
      auto_https disable_redirects
    '';
    virtualHosts = {
      # Main domain root -> Site Monitor
      "nixos-2.tail113143.ts.net" = {
        extraConfig = ''
          reverse_proxy 127.0.0.1:8082
        '';
      };

      # Stirling-PDF (Document Utilities)
      "nixos-2.tail113143.ts.net:3001" = {
        extraConfig = ''
          reverse_proxy 127.0.0.1:8080
        '';
      };

      # HedgeDoc (Document Editor)
      "nixos-2.tail113143.ts.net:3000" = {
        extraConfig = ''
          reverse_proxy 127.0.0.1:3005
        '';
      };

      # Jellyfin
      "nixos-2.tail113143.ts.net:4096" = {
        extraConfig = ''
          reverse_proxy 127.0.0.1:8096
        '';
      };

      # Kavita
      "nixos-2.tail113143.ts.net:50000" = {
        extraConfig = ''
          reverse_proxy 127.0.0.1:5001
        '';
      };

      # Motion
      "nixos-2.tail113143.ts.net:4081" = {
        extraConfig = ''
          reverse_proxy 127.0.0.1:8081
        '';
      };

      # Photos
      "nixos-2.tail113143.ts.net:4777" = {
        extraConfig = ''
          reverse_proxy 127.0.0.1:9777
        '';
      };

      # yt-dlp web UI
      "nixos-2.tail113143.ts.net:4097" = {
        extraConfig = ''
          reverse_proxy 127.0.0.1:8097
        '';
      };
    };
  };
}