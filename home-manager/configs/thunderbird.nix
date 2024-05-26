{ config, pkgs, ... }:
{
  programs.thunderbird = {
    enable = true;
    profiles = {
      nyx = {
        isDefault = true;
        # name = "Main";
      };
    };
    settings = {
      "privacy.donottrackheader.enabled" = true;
    };
  };
}