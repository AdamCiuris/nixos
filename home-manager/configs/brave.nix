{ config, pkgs, ... }:{
  programs = {
    chromium = {
      enable = true;
      package = pkgs.brave;
      extensions = [
        "dhdgffkkebhmkfjojejmpbldmpobfkfo" # tampermonkey, https://www.tampermonkey.net/index.php?ext=dhdg&updated=true&version=5.1.1

      ];
    };
  };
}