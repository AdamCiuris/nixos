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
  enable = true;
  listenAddresses = [ "0.0.0.0:631" ];
  drivers = with pkgs; [ 
    gutenprint
    hplip
    splix
    cnijfilter2
    gutenprint
    gutenprintBin
  ];
  allowFrom = [ "all" ];
  browsing = true;
  defaultShared = true;
  openFirewall = true;
};
  networking.firewall.allowedTCPPorts = [ 631 ];
  networking.firewall.allowedUDPPorts = [ 631 ];
}