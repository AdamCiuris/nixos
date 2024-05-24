{ config, pkgs, ...}:
{
  programs.firefox = {
      enable = true;

      profiles.nyx = {
        isDefault = true;
        # extensions =  {
        #   "TamperMonkey"
        # };
        settings = {
          "browser.startup.homepage" = "https://open.spotify.com/";
        };
        search.force = true; # rm whatever config is already there
        search.default = "DuckDuckGo";
        search.engines = {
          "Nix Packages" = {
            urls = [{
              template = "https://search.nixos.org/packages";
              params = [
                { name = "type"; value = "packages"; }
                { name = "query"; value = "{searchTerms}"; }
              ];
            }];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ ":np" ];
          };
          "Nix Options" = {
            urls = [{
              template = "https://search.nixos.org/options";
              params = [
                { name = "type"; value = "packages"; }
                { name = "query"; value = "{searchTerms}"; }
              ];
            }];

            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ ":no" ];
          };

          "NixOS Wiki" = {
            urls = [{ template = "https://wiki.nixos.org/index.php?search={searchTerms}"; }];
            iconUpdateURL = "https://wiki.nixos.org/favicon.png";
            updateInterval = 24 * 60 * 60 * 1000; # every day
            definedAliases = [ ":w" ];
          };

          "YouTube" = {
            urls = [{ template = "https://www.youtube.com/results?search_query={searchTerms}"; }];
            icon = "https://www.youtube.com/favicon.ico";
            definedAliases = [ ":yt" ];
          };
          "GitHub Code" = {
            urls = [{ template = "https://github.com/search?q={searchTerms}&type=code"; }];
            icon = "https://github.githubassets.com/favicons/favicon.png";
            definedAliases = [ ":gh" ];
          };

          "Bing".metaData.hidden = true;
          "Google".metaData.alias = ":g"; # builtin engines only support specifying one additional alias
        };
      };

  };

}

