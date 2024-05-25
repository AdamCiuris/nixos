{ config, pkgs, ... }:
{
  virtualisation = {
    docker = {
      enable = true;
      enableOnBoot = true;
      autoPrune.enable = true;
      autoPrune.flags = [ "--all" ]; # docker system prune --all
      autoPrune.dates = "1month"; # prune monthly
    };
  };
}