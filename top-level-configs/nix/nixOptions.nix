{ config, pkgs,  ... }: 
{
  gc.automatic = true;
	gc.options = "--delete-older-than 20d";
	settings.experimental-features = ["nix-command" "flakes"]; # needed to try flakes from tutorial

}