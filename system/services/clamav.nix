{ config, pkgs, ... }:
{
  services.clamav = {
    scanner.enable = true;
    updater.enable = true;

    daemon.enable = true;

  };
}