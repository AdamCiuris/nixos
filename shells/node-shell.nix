{pkgs ? import <nixpkgs> { overlays = [(import ../overlay.nix)];}}:

let 
  inherit (pkgs) stdenv;
in
pkgs.mkShell {
    name = "node";
    packages = with pkgs; [ 
        nodejs-18_x (yarn.override (_: {
      nodejs = nodejs-18_x;
    })) # passing yarn into node then binding node into yarn aaaaaaaaaaa
    ];
    shellHook = ''
        export PATH="$PWD/node_modules/.bin/:$PATH"
        export NPM_PACKAGES="$HOME/.npm-packages"
    '';
}
