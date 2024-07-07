{ config, pkgs, ... }:
{
  services.ollama = {
      enable = true;
      listenAddress = "127.0.0.1:65020";
  };
}