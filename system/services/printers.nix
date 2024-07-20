{ config, pkgs, ... }:
{
  services.avahi = {
  enable = true;
  nssmdns4 = true;
  openFirewall = true;
  publish = {
    enable = true;
    userServices = true;
  };
};
services.printing = {
  listenAddresses = [ "*:631" ];
  allowFrom = [ "all" ];
  browsing = true;
  defaultShared = true;
  openFirewall = true;
};
  networking.firewall.allowedTCPPorts = [ 631 ];
  networking.firewall.allowedUDPPorts = [ 631 ];
}