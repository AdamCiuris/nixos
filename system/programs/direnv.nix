{ config, pkgs, ... }:
{
  programs.direnv = {
    enable = true;
    direnvrcExtra = ''
    echo "loaded direnv!"
    '';
  };
}