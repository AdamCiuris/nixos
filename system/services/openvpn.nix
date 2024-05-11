{ config, pkgs, ... }:
{
  programs.openvpn3.enable = true;
  services.openvpn.servers = {
    me = {
      autoStart = true; # Start the server on boot
      config = '' config /etc/openvpn/server.ovpn '';
    };

  };
}