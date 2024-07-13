{ config, pkgs, ... }:
{
  services.ollama = {
      enable = true;
      listenAddress = "0.0.0.0:11434";
      # openFirewall = true;
  };
  networking.firewall.allowedTCPPorts = [ 11434 ]; # should be closed if alloff imported
}