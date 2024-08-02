{ config, lib, pkgs, ... }:
let
ab=1;
  # let nixGetEnt = "${lib.getExe pkgs.getent}"; in ''builtins.readFile ./vpnfailsafe.sh'';
  nixGetEnt = "${lib.getExe pkgs.getent}"; 
  
in
{
  # environment.systemPackages = [ pkgs.getent ];
  programs.openvpn3.enable = true;
  services.openvpn.servers = {
    me = { # sudo chmod -R 700  /etc/openvpn
      autoStart = true; # Start the server on boot
      config = '' config /etc/openvpn/server.ovpn '';
#       up = ''
# if [ -f "/tmp/iptablesbkup" ]; then
#   iptables-restore < /tmp/iptablesbkup
#   rm /tmp/iptablesbkup
# fi
# '';

      down= ''
iptables-save > /tmp/iptablesbkup  
iptables -F
ip6tables -F
iptables -A INPUT -j REJECT
iptables -A OUTPUT -j REJECT
iptables -A FORWARD -j REJECT
ip6tables -A INPUT -j REJECT
ip6tables -A OUTPUT -j REJECT
ip6tables -A FORWARD -j REJECT
'';
    };

  };
}