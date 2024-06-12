{ config, pkgs, ... }:
{
  programs = {
    chromium = {
      enable = true;
      package = pkgs.opera;
      extensions = [
      ];

    };
  };
}