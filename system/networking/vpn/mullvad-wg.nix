{ config, pkgs, ... }:
{
  networking.wg-quick.interfaces.mullvad = {
    autostart = true;
    configFile = "/etc/wireguard/conf/current.conf"; 
  };

  # Dig into Home Manager from the system level (assuming your username is nyx)
  home-manager.users.nyx = {
    
    # Home Manager will automatically APPEND this to the shellExtra 
    # you already defined in your other Home Manager file.
    programs.zsh.initExtra = ''
      mullvad_swap() {
          local conf_dir="/etc/wireguard/conf"
          local current_conf="$conf_dir/current.conf"
          local target_conf="$1"

          if [[ -z "$target_conf" ]]; then
              target_conf=$(find "$conf_dir" -maxdepth 1 -name "*.conf" ! -name "current.conf" -exec basename {} \; | shuf -n 1)
              
              if [[ -z "$target_conf" ]]; then
                  echo "Error: No configuration files found in $conf_dir to randomize."
                  return 1
              fi
              echo "No server specified. Randomly selected: $target_conf"
          else
              if [[ ! "$target_conf" == *.conf ]]; then
                  target_conf="$target_conf.conf"
              fi
          fi

          local source_path="$conf_dir/$target_conf"

          if [[ ! -f "$source_path" ]]; then
              echo "Error: Configuration file '$source_path' not found."
              return 1
          fi

          local active_fwmark
          active_fwmark=$(sudo wg show mullvad fwmark 2>/dev/null)
          
          if [[ -z "$active_fwmark" || "$active_fwmark" == "off" ]]; then
              active_fwmark=51820
          fi

          sudo cp "$source_path" "$current_conf"
          sudo chmod 600 "$current_conf"

          local tmp_conf="/tmp/wg_hotswap.conf"
          sudo bash -c "wg-quick strip \"$current_conf\" | awk '/\\[Interface\\]/{print; print \"FwMark = $active_fwmark\"; next}1' > $tmp_conf"
          sudo chmod 600 "$tmp_conf"

          sudo wg syncconf mullvad "$tmp_conf"
          sudo rm -f "$tmp_conf"
          
          echo "Tunnel successfully routed to $target_conf."
      }
    '';

    # Optional: Do the exact same thing for bash if you ever drop into it
    programs.bash.initExtra = config.home-manager.users.nyx.programs.zsh.initExtra;
  };
}