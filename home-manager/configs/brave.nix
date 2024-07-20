{ config, pkgs, ... }:
{
  programs = {
    chromium = {
      enable = true;
      package = pkgs.brave;
      extensions = [
        "dhdgffkkebhmkfjojejmpbldmpobfkfo" # tampermonkey, https://www.tampermonkey.net/index.php?ext=dhdg&updated=true&version=5.1.1
        "dneaehbmnbhcippjikoajpoabadpodje" # new to old reddit, im sorry https://chromewebstore.google.com/detail/old-reddit-redirect/dneaehbmnbhcippjikoajpoabadpodje
        "cjpalhdlnbpafiamejdnhcphjbkeiagm" # uBlock Origin https://chromewebstore.google.com/detail/ublock-origin/cjpalhdlnbpafiamejdnhcphjbkeiagm
      ];

      # extraOpts = {
      #       "BrowserSignin" = 0;
      #       "SyncDisabled" = true;
      #       "PasswordManagerEnabled" = false;
      #       "SpellcheckEnabled" = true;
      # };
    };
  };
}