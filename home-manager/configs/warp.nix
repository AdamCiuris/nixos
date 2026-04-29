{  config, pkgs, ...}:
{
  environment.systemPackages = [
    pkgs.warp-terminal
  ];
}