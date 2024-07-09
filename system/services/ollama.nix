{ config, pkgs, ... }:
{
  services.ollama = {
      enable = true;
      listenAddress = "127.0.0.1:65020";
  };
  # networking.firewall.allowedTCPPorts = [ 65020 ]; # should be closed if alloff imported
}