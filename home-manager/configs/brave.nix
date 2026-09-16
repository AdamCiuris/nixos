{ config, pkgs, ... }:
{
  programs = {
    chromium = {
      enable = true;
      package = pkgs.unstable.brave;
      extensions = [
        "dhdgffkkebhmkfjojejmpbldmpobfkfo" # tampermonkey, https://www.tampermonkey.net/index.php?ext=dhdg&updated=true&version=5.1.1
        "cjpalhdlnbpafiamejdnhcphjbkeiagm" # uBlock Origin https://chromewebstore.google.com/detail/ublock-origin/cjpalhdlnbpafiamejdnhcphjbkeiagm
        "nngceckbapebfimnlniiiahkandclblb" # bitwarden https://chromewebstore.google.com/detail/bitwarden-password-manage/nngceckbapebfimnlniiiahkandclblb
      ];
    };
  };
}
