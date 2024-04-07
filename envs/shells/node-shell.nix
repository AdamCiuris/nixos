{pkgs ? import <nixpkgs> { 

  overlays = [(import ./node.nix)];}}:


  with pkgs;
let
  packages = rec {

    # The derivation for chord
    cmake-js = stdenv.mkDerivation rec {
      pname = "cmake-js";
      version = "7.0.0";
      src = fetchurl {
        url = "https://github.com/cmake-js/cmake-js/archive/refs/tags/v${version}.tar.gz";
        # rev = "069d2a5bfa4c4024063c25551d5201aeaf921cb3";
        sha256 = "sha256-yrWzElxYP7y9ovWU5A1SkI9oo1hzVIeFfQ06wzF9tq8=";
      };

    };

    expEnv = mkShell rec {
      name = "node";
      packages = with pkgs; [
        cmake 
        glibc
			(python3.withPackages (python-pkgs: with python-pkgs; [
				pandas
				numpy
        setuptools
			]))
          nodejs-18_x (yarn.override (_: {
        nodejs = nodejs-18_x;
      })) # passing yarn into node then binding node into yarn aaaaaaaaaaa
      ];
      shellHook = ''
          export PATH="$PWD/node_modules/.bin/:$PATH"
          export NPM_PACKAGES="$HOME/.npm-packages"
      '';
        # buildInputs = [
        #   cmake-js
        # ];
    };

  };
in
  packages

