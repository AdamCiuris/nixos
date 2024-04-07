{ pkgs, config, ... }:
let
  nix-index = import(pkgs.fetchFromGitHub {
    owner = "nix-community";
    repo = "nix-index";
    rev= "b5fcd082f474d41b11e01aa8f8f3131ae40f8952";
    sha256 = "sha256-UJenH6w80dGVDTA2aXbstj10x1i+fkEhJbamO0jotiE=";
});
in
{
  environment = {
    systemPackages = [ nix-index ];
  };
}