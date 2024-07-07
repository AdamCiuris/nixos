{ config, pkgs, lib, ... }:
{
  	networking.firewall =  {
        enable = true; # this is on by default but still declaring it.
        allowedTCPPorts = lib.mkForce [  ];
        allowedUDPPorts = lib.mkForce [  ];
        logRefusedConnections = true; 
	};
}