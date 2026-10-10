{ config, pkgs, ...}:
{
  programs.firefox = {
      enable = true;

      profiles.nyx = {
        isDefault = true;
        extensions = 
          {
            packages = with pkgs.nur.repos.rycee.firefox-addons; [
              leechblock-ng # Website blocker for focus and productivity
              ublock-origin # Comprehensive ad, tracker, and script blocker
              bitwarden     # Encrypted password and credentials manager
              violentmonkey # Userscript manager for injecting custom JavaScript into pages
              downthemall   # Mass download manager with multi-threading and auto-resuming
            ];
          };
        settings = {
          # --- STARTUP & SESSION RESTORE ---
          
          "browser.startup.page" = 3;
          
          # Read the homepage string directly from the local file
          "browser.startup.homepage" = "https://calendar.google.com/calendar/u/0/r";
          
          "places.history.enabled" = true;

          "privacy.sanitize.sanitizeOnShutdown" = true;
          "privacy.clearOnShutdown.cache" = true;
          "privacy.clearOnShutdown.offlineApps" = true;
          
          # Preserve history, active logins, site sessions, and form autofill data across restarts
          "privacy.clearOnShutdown.history" = false; 
          "privacy.clearOnShutdown.formdata" = false; 
          "privacy.clearOnShutdown.passwords" = false;
          "privacy.clearOnShutdown.cookies" = false;
          "privacy.clearOnShutdown.sessions" = false;

          # --- UI & THEMING ---
          
          "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
          "ui.systemUsesDarkTheme" = 1;
          "browser.in-content.dark-mode" = true;
          "browser.theme.content-theme" = 0;
          "layout.css.devPixelsPerPx" = "0.9";
          "browser.uidensity" = 1; 

          # Force websites to use their dark theme (0 = dark, 1 = light, 2 = system, 3 = browser)
          "layout.css.prefers-color-scheme.content-override" = 0;

          # Pin History, Downloads, Logins, and native offline Translations button to the main toolbar
          "browser.uiCustomization.state" = ''
            {
              "placements": {
                "widget-overflow-fixed-list": [],
                "unified-extensions-area": [],
                "nav-bar": [
                  "back-button",
                  "forward-button",
                  "stop-reload-button",
                  "urlbar-container",
                  "downloads-button",
                  "history-panelmenu",
                  "logins-button",
                  "translations-button",
                  "unified-extensions-button"
                ],
                "toolbar-menubar": [
                  "menubar-items"
                ],
                "TabsToolbar": [
                  "tabbrowser-tabs",
                  "new-tab-button",
                  "alltabs-button"
                ],
                "PersonalToolbar": [
                  "personal-bookmarks"
                ]
              },
              "seen": [
                "developer-button"
              ],
              "dirtyAreaCache": [
                "nav-bar",
                "PersonalToolbar",
                "unified-extensions-area"
              ],
              "currentVersion": 20,
              "newElementCount": 0
            }
          '';

          "browser.download.autohideButton" = false;
          "intl.accept_languages" = "en-US, en, ru-RU, ru";
          "extensions.autoDisableScopes" = 0;
          "devtools.toolbox.host" = "right";
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

          # --- BLANK NEW TAB PAGE & ACTIVITY STREAM REMOVAL ---
          
          "browser.newtabpage.enabled" = false;
          "browser.newtabpage.activity-stream.enabled" = false;
          "browser.newtabpage.activity-stream.telemetry" = false;
          "browser.newtabpage.activity-stream.feeds.telemetry" = false;
          "browser.newtabpage.activity-stream.feeds.snippets" = false;
          "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
          "browser.newtabpage.activity-stream.feeds.discoverystreamfeed" = false;
          "browser.newtabpage.activity-stream.feeds.topsites" = false;
          "browser.newtabpage.activity-stream.showSponsored" = false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
          "browser.newtabpage.activity-stream.default.sites" = "";

          # --- HARDENED PRIVACY & NETWORKING ---
          
          "network.cookie.cookieBehavior" = 5;
          "privacy.resistFingerprinting" = true;
          "media.peerconnection.ice.default_address_only" = true;
          "network.trr.mode" = 2;

          # Disable geolocation requests completely
          "geo.enabled" = false;

          # --- WORKFLOW, SPELLING & BEHAVIORS ---
          
          "reader.parse-on-load.enabled" = false;
          "media.autoplay.default" = 5;
          "media.videocontrols.picture-in-picture.enabled" = true;
          "browser.ctrlTab.sortByRecentlyUsed" = false;
          
          # Enable simultaneous English and Russian spellchecking in all text fields
          "spellchecker.dictionary" = "en-US,ru-RU";
          "layout.spellcheckDefault" = 2;

          # --- ANIMATIONS & REDUCED MOTION ---
          
          "toolkit.cosmeticAnimations.enabled" = false;
          "browser.tabs.animate" = false;
          "browser.download.animateNotifications" = false;
          "ui.prefersReducedMotion" = 1;

          # --- HARDWARE ACCELERATION ---
          
          "media.ffmpeg.vaapi.enabled" = true;
          "gfx.webrender.all" = true;

          # --- PERFORMANCE TWEAKS ---
          
          # Disable disk cache and force RAM caching
          "browser.cache.disk.enable" = false;
          "browser.cache.memory.enable" = true;
          
          # Enable TCP Fast Open and HTTP/3
          "network.tcp.tcp_fastopen_enable" = true;
          "network.http.http3.enable" = true;
          
          # Prevent accessibility services from hooking into the browser (0=default, 1=disabled)
          "accessibility.force_disabled" = 1;

          # --- DESKTOP INTEGRATION (CINNAMON/GTK) ---
          
          "browser.tabs.inTitlebar" = 0;
          "widget.gtk.native-context-menus" = false;
          "widget.use-xdg-desktop-portal.file-picker" = 1;

          # --- SYNC & ACCOUNTS ---
          
          "identity.fxaccounts.enabled" = false;

          # --- AI & SIDEBAR DEBLOAT ---
          
          "browser.ml.chat.enabled" = false;
          "browser.ml.chat.sidebar" = false;
          "sidebar.revamp" = false;

          # --- BOOKMARKS & TOOLBARS ---
          
          "browser.toolbars.bookmarks.visibility" = "newtab";

          # --- TELEMETRY AND DATA COLLECTION ---
          
          "toolkit.telemetry.unified" = false;
          "toolkit.telemetry.enabled" = false;
          "toolkit.telemetry.server" = "data:,";
          "toolkit.telemetry.archive.enabled" = false;
          "toolkit.telemetry.newProfilePing.enabled" = false;
          "toolkit.telemetry.shutdownPingSender.enabled" = false;
          "toolkit.telemetry.updatePing.enabled" = false;
          "toolkit.telemetry.bhrPing.enabled" = false;
          "toolkit.telemetry.firstShutdownPing.enabled" = false;
          "toolkit.telemetry.coverage.opt-out" = true;
          "toolkit.coverage.endpoint.base" = "";
          "datareporting.healthreport.uploadEnabled" = false;
          "datareporting.policy.dataSubmissionEnabled" = false;
          "app.shield.optoutstudies.enabled" = false;
          "app.normandy.enabled" = false;
          "app.normandy.api_url" = "";
          "breakpad.reportURL" = "";
          "browser.tabs.crashReporting.sendReport" = false;
          "browser.crashReports.unsubmittedCheck.autoSubmit2" = false;
          "browser.ping-centre.telemetry" = false;

          # --- HISTORY & SEARCH SUGGESTIONS ---
          
          "browser.formfill.enable" = true;
          "browser.search.suggest.enabled" = false;
          "browser.urlbar.suggest.searches" = false;
          "browser.urlbar.suggest.history" = false;
          "browser.urlbar.suggest.bookmark" = false;
          "browser.urlbar.suggest.openpage" = false;

          # --- ADDITIONAL PRIVACY & INTEGRATIONS ---

          "signon.rememberSignons" = true;
          "signon.autofillForms" = true;
          "extensions.pocket.enabled" = false;
          
          # Prefetching explicitly disabled to prioritize privacy over background loading.
          "network.dns.disablePrefetch" = true;
          "network.prefetch-next" = false;
          
          "dom.security.https_only_mode" = true;
          "dom.security.https_only_mode_send_http_background_request" = false;

          # --- ANNOYANCE REMOVAL ---
          
          "browser.startup.homepage_override.mstone" = "ignore";
          "browser.shell.checkDefaultBrowser" = false;
          "full-screen-api.warning.timeout" = 0;
          
          # Disable web notification popups completely
          "dom.webnotifications.enabled" = false;

        };
        
        userChrome = ''
          /* 
- Add your custom Cinnamon-matching CSS here.
           */
        '';

        search.force = true;
        search.default = "Brave";
        search.engines = {
          "Brave" = {
            urls = [{ template = "https://search.brave.com/search?q={searchTerms}"; }];
            icon = "${./data/brave_search.png}";
            definedAliases = [ ":b" ":и" ];
          };
          "Nix Packages" = {
            urls = [{
              template = "https://search.nixos.org/packages";
              params = [
                { name = "type"; value = "packages"; }
                { name = "query"; value = "{searchTerms}"; }
              ];
            }];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ ":np" ":тз" ];
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
            definedAliases = [ ":no" ":тщ" ];
          };
          "NixOS Wiki" = {
            urls = [{ template = "https://wiki.nixos.org/index.php?search={searchTerms}"; }];
            icon = "https://wiki.nixos.org/favicon.png";
            updateInterval = 24 * 60 * 60 * 1000;
            definedAliases = [ ":w" ":ц" ];
          };
          "youtube" = {
            urls = [{ template = "https://www.youtube.com/results?search_query={searchTerms}"; }];
            icon = "https://www.youtube.com/favicon.ico";
            definedAliases = [ ":yt" ":не" ];
          };
          "GitHub Code" = {
            urls = [{ template = "https://github.com/search?q={searchTerms}&type=code"; }];
            icon = "https://github.githubassets.com/favicons/favicon.png";
            definedAliases = [ ":gh" ":пр" ];
          };
          "Yandex" = {
            urls = [{ template = "https://yandex.com/search/?text={searchTerms}"; }];
            icon = "https://yandex.com/favicon.ico";
            definedAliases = [ ":ya" ":нф" ];
          };
          "bing".metaData.hidden = true;
          "google".metaData.alias = ":g";
        };
      };
  };
}