{ config, pkgs, ...}:
let
  
  bashExtra = ''
  eval "$(direnv hook bash)"
  '';
  
  zshExtra = ''
  eval "$(direnv hook zsh)" # makes direnv work
  # scan local network for open ports
  # nmap -p 1-65535 localhost
  # echo "\"nix-shell -p 'lsof -i :<port> -S'\" to see what's using it"
  '';
  
  shellExtra =  ''
    # BEGIN XDG_DATA_DIRS CHECK
    # used to add .desktop files to xdg-mime from nix profile if dne
    # TODO figure out why this gets entered every home-manager switch
    xdgCheck="$HOME/.nix_profile/share/applications"
    if  [[ ":$XDG_DATA_DIRS:" != *":$xdgCheck:"* ]] ; then
      export XDG_DATA_DIRS="$xdgCheck${":$XDG_DATA_DIRS"}"
    fi  
    # ENd XDG_DATA_DIRS CHECK
    
    # BEGIN FUNCTIONS
    opts() {
      # opens a new firefox in a nix-shell on the nixos options page, pipes to nohup's thing and detaches from shell with &
      nohup nix-shell --pure -p mullvad-browser --run "mullvad-browser https://search.nixos.org/options" -- 2>&1 &
    }
    
    discord() {
      local NIXPKGS_ALLOW_UNFREE=1 nohup nix-shell --pure -p discord  --command discord -- 2>&1 & 
    }
    
    pvenv() {
      # starts a python virtual environment named after first arg and if a path to a requirements file is provided as second arg it installs it
      # "deactivate" leaves the venv
      local firstArg="$1"
      local activate="./$firstArg/bin/activate"
      python -m venv $firstArg 
      if [ ! -z "$2" ]; then
        source $activate && pip install -r $2 && echo "deactivate to leave"
      else
        source $activate && echo "deactivate to leave"
      fi
    }
    
    apt-remove() {
      # removes a package from apt and nix
      local firstArg="$1"
      sudo apt-get remove $(apt list --installed "$firstArg" 2>/dev/null | awk -F'/' 'NR>1{print $1}')
    }
    
    desktopFiles() {
      local firstArg="$1"
      echo "searching for $firstArg in $HOME/.nix-profile/share/applications/..."
      ls ~/.nix-profile/share/applications | grep "$firstArg"
      echo "searching for $firstArg in /usr/share/applications/..."
      ls /usr/share/applications | grep "$firstArg"
    } 
    
    countFiles() {
      local firstArg="$1"
      local A=$(ls -a |  wc -l)
      local B=$($A-2)
      echo $B
    }
    
    # Capture command output to a temp file while displaying it
    cx() {
        "$@" 2>&1 | tee /tmp/last_cmd_output.txt
    }
    
    tailnet_browser() {
      (
        # Create the temporary directory
        local tmp_dir=$(mktemp -d)
        
        # Check XDG directory first, fallback to legacy Mozilla directory
        local ff_base=""
        if [ -d "$HOME/.config/mozilla/firefox" ]; then
          ff_base="$HOME/.config/mozilla/firefox"
        else
          ff_base="$HOME/.mozilla/firefox"
        fi
        
        local src_profile=""
        
        # 1. Try to read the exact path from Firefox's profiles.ini
        if [ -f "$ff_base/profiles.ini" ]; then
          local rel_path=$(awk -F= '/^Path=/ {print $2}' "$ff_base/profiles.ini" | head -n 1)
          if [ -n "$rel_path" ]; then
            if [[ "$rel_path" = /* ]]; then
              src_profile="$rel_path"
            else
              src_profile="$ff_base/$rel_path"
            fi
          fi
        fi

        # 2. BULLETPROOF FALLBACK: Search for the actual profile database
        if [ -z "$src_profile" ] || [ ! -d "$src_profile" ]; then
          src_profile=$(find "$ff_base" -maxdepth 2 -type f -name "places.sqlite" -exec dirname {} \; | head -n 1)
        fi

        # Copy settings, passwords, extensions, and bookmarks to the tmp directory
        if [ -n "$src_profile" ] && [ -d "$src_profile" ]; then
          echo "Copying Firefox profile from: $src_profile"
          
          # Use -rL to dereference NixOS symlinks, turning them into actual files
          cp -rL "$src_profile/"* "$tmp_dir/" 2>/dev/null
          
          # Nix store files are read-only. Make everything writable
          chmod -R u+w "$tmp_dir"
          
          # Delete lock files and temporary journals for passwords
          rm -f "$tmp_dir/parent.lock" "$tmp_dir/lock"
          rm -f "$tmp_dir"/*.sqlite-wal "$tmp_dir"/*.sqlite-shm
          
          # Delete session restore files so old tabs do not carry over
          rm -rf "$tmp_dir/sessionstore-backups" "$tmp_dir/sessionstore.jsonlz4"
        else
          echo "Warning: Could not find ANY Firefox profile in $ff_base. Starting with a blank profile."
        fi
        
        # Inject overrides and Tailscale settings
        cat <<EOF >> "$tmp_dir/user.js"

// --- INJECTED TEMPORARY SETTINGS ---
// Prevent session restore and override homepage (kills the Google Calendar default)
user_pref("browser.startup.page", 1); 
user_pref("browser.startup.homepage", "about:blank");

// Tailscale Proxy
user_pref("network.proxy.type", 1);
user_pref("network.proxy.socks", "10.99.0.2");
user_pref("network.proxy.socks_port", 1055);
user_pref("network.proxy.socks_remote_dns", true);
EOF
        
        # Launch Firefox with the temporary profile as an isolated instance
        firefox --no-remote --new-instance --profile "$tmp_dir" "$@" >/dev/null 2>&1
        
        # Wait for the isolated window to close, then cleanly remove the temporary directory
        rm -rf "$tmp_dir"
      ) &
      
      # Detach from terminal
      disown
    }
    
    pathappend() {
      for ARG in "$@"
      do
        if [ -d "$ARG" ] && [[ ":$PATH:" != *":$ARG:"* ]]; then
          PATH="${"$PATH:"}$ARG"
        fi
      done
    }
    
    pathprepend() {
      for ARG in "$@"
      do
        if [ -d "$ARG" ] && [[ ":$PATH:" != *":$ARG:"* ]]; then
          PATH="$ARG${":$PATH"}"
        fi
      done
    } # END FUNCTIONS


    # BEGIN ALIASES
    alias src="source"; 
    alias resrc="source ~/.zshrc";
    alias ...="../../"; 
    alias nrs="sudo nixos-rebuild switch"; 
    
    alias "g*"="git add *"; 
    alias gcm="git commit -m";
    alias gp="git push"; # conflicts with global-platform-pro, pari
    alias gpl="git pull";
    alias gco="git checkout";
    alias gbr="git branch";
    alias gcl="git clone";
    alias glog="git log";
    alias gdiff="git diff";
    alias gstat="git status";
    
    alias hms="rm -f ~/.config/mimeapps.list && home-manager switch";
    alias LS="ls -lAh";
    alias CD="cd";
    alias "cd.."="cd ..";
    alias "cd..."="cd ../..";

    alias "SUDO"="sudo";
    alias "SUDO!"="sudo !!";

    alias shutr="shutdown -r now ; systemd-inhibit --list"
    alias shut="shutdown now ; systemd-inhibit --list"

    alias ipy="type ipy && \
    nix-shell -p 'python3.withPackages (python-pkgs: with python-pkgs; [
            ipython
            matplotlib
            scipy
            scikit-learn
            pandas
            numpy
            requests
            pysocks
        ])' --run ipython"

    alias crontab-reboot-test="sudo rm /var/run/crond.reboot && sudo service cron restart"
    alias code=codium
    # click kill thing
    alias xkill="nix-shell -p xorg.xkill --run xkill"
    alias mkill="nix-shell -p xorg.xkill --run xkill"
    alias mousekill="nix-shell -p xorg.xkill --run xkill"
    
    # END ALIASES
    '';
    

in
{
  # BEGIN BASH
  programs.bash ={
    enable=true;
    historyControl = ["ignoredups"];
    initExtra =  shellExtra;
  }; # END BASH
  # BEGIN ZSH
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    oh-my-zsh={
      enable = true;
      plugins = [ "git" "sudo" "systemd" "python"]; 
      theme = "agnoster";  
      };
    initContent = zshExtra + shellExtra;
  }; # END ZSH
}