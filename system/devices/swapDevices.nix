# https://phoenixnap.com/kb/linux-swap-file
# https://search.nixos.org/options?channel=23.11&show=swapDevices&from=0&size=50&sort=relevance&type=packages&query=swap
{ config, pkgs, ... }:
{
  swapDevices = [
    {
      device = "/__swapfile__";
      size = 1024*32; # in MiB, 32 GiB
      # label = "swap";
    }
  ];
}