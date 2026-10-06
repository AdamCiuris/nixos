{ config, pkgs, ... }:
{
  imports = [
    ./vpn/mullvad-wg.nix
  ];

  networking = {   
    hostName = "nixos";
    enableIPv6 = true; # ipv4 only pls
    
    networkmanager = {
      enable = true;
    };
  # networking.firewall.checkReversePath = "loose";

    firewall = {
      enable = true;
    };
  };


}