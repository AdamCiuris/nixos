{ config, pkgs, ... }:
{
  	networking = 
        {   
            # bind hostname in import
            hostName = "nixos";
            enableIPv6 = false; # ipv4 only pls
            networkmanager.enable = true;
            # logRefusedConnections =true;# logs are in dmesg or journalctl -k
        };
}