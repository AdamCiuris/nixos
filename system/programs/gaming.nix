{ pkgs, ... }:
# https://www.youtube.com/watch?v=qlfm3MEbqYA
{
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };
  programs.gamemode.enable = true;
}