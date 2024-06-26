{ config, pkgs, ...}: 		# xdg-open is what gets called from open "file" in terminal
let
  browser = ["brave"];
  imageViewer = ["nomacs"];
  videoPlayer = ["vlc"];
  audioPlayer = ["vlc"];
  scriptViewer = ["code"];

  xdgAssociations = type: program: list:
    builtins.listToAttrs (map (e: {
        name = "${type}/${e}";
        value = program;
      })
      list);

  image = xdgAssociations "image" imageViewer ["png" "svg" "jpeg" "jpg" "gif" "webp" "bmp" "tiff" "svg+xml"];
  video = xdgAssociations "video" videoPlayer ["mpeg" "avi" "mkv" "quicktime" "webm"];
  scripts = xdgAssociations "text" scriptViewer ["sh" "bash" "zsh" "fish" "py" "pl" "rb" "lua" "js" "ts" "html" "css" "json" "yaml" "toml" "xml" "md" "markdown" "rst" "txt"];
  audio = xdgAssociations "audio" audioPlayer ["mpeg" "flac" "wav" "aac"];
  browserTypes =
    (xdgAssociations "application" browser [
      "json"
      "x-extension-htm"
      "x-extension-html"
      "x-extension-shtml"
      "x-extension-xht"
      "x-extension-xhtml"
    ])
    // (xdgAssociations "x-scheme-handler" browser [
      "about"
      "ftp"
      "http"
      "https"
      "unknown"
    ]);

  # XDG MIME types
  associations = builtins.mapAttrs (_: v: (map (e: "${e}.desktop") v)) ({
      "application/pdf" = ["brave.desktop"];
      "text/html" = browser;
      "text/plain" = ["code.desktop"];
      "x-scheme-handler/chrome" = ["brave.desktop"];
      "inode/directory" = ["nemo"];
    }
    // image
    // video
    // audio
    // scripts
    // browserTypes);
in {
  xdg = {
    enable = true;
    # cacheHome = config.home.homeDirectory + "/.local/cache";

    mimeApps = {
      enable = true;
      defaultApplications = associations;
    };

    # userDirs = {
    #   enable = true;
    #   createDirectories = true;
    #   extraConfig = {
    #     XDG_SCREENSHOTS_DIR = "${config.xdg.userDirs.pictures}/Screenshots";
    #   };
    # };
  };

}