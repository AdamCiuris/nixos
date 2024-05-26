{ config, pkgs, ... }: 
{
  services.flatpak.enable = false; # need for postman as postman isn't updated as of 01/28/24
}