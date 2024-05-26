{ config, pkgs, ... }:
{
  	networking.firewall =  {
        enable = true; # this is on by default but still declaring it.
        allowedTCPPorts = [  ];
        allowedUDPPorts = [  ];
        logRefusedConnections = true; 
	};
}