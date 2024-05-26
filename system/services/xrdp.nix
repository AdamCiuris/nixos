{ config, pkgs, ... }: 
{
  xrdp = {
      enable = true;
      defaultWindowManager = "startplasma-x11";
      confDir = /etc/xrdp;
      port = 8181;
      openFirewall=false; # https://c-nergy.be/blog/?p=14965/
    };
}