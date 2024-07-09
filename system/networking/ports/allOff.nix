{ config, pkgs, lib, ... }:
{
  	networking.firewall =  {
        enable = true; # this is on by default but still declaring it.
        allowedTCPPorts = lib.mkForce [  ];
        allowedUDPPorts = lib.mkForce [  ];
        logRefusedConnections = true; 


      # iptables -P INPUT DROP # stop all incoming traffic
      # iptables -P FORWARD DROP # stop all forwarding traffic
      # iptables -P OUTPUT DROP # stop all outgoing traffic
      # https://www.ibm.com/docs/en/linux-on-systems?topic=tests-firewall-iptables-rules
      extraCommands = ''
          iptables -P INPUT DROP
      '';
	};
}