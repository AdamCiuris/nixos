{ config, pkgs, ... }:
{
  services.tor.enable = true;
  # environment.systemPackages = with pkgs; [
  #   torctl
  # ];
}