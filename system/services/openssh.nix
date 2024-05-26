{ config, pkgs, ... }:
{
  openssh = {
    enable = true;
    permitRootLogin = "no";
    passwordAuthentication = false; # if false require pub key
  };
}