{ config, pkgs, ... }:
{
    services.spice-vdagentd.enable = true; # enables clipboard sharing between host and guest
}