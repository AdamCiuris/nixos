{ config, pkgs, ... }:
{
  dconf.enable = true;
    dconf.settings = {
    # rm annoying cinnamon alt click move window shortcut
    "org/cinnamon/desktop/wm/preferences" = {
      mouse-button-modifier = "disabled";
    };
    # Register the custom shortcut in Cinnamon's shortcut list
    # (Cinnamon usually initializes this list with a "__dummy__" entry)
    "org/cinnamon/desktop/keybindings" = {
      custom-list = [ "__dummy__" "custom-xclip" ];
    };

    # 3. prepend to naively pipe cmd output to paste into claude
    "org/cinnamon/desktop/keybindings/custom-keybindings/custom-xclip" = {
      name = "cx to xclip";
      command = "sh -c \"cat /tmp/last_cmd_output.txt | xclip -selection clipboard\"";
      binding = [ "<Control><Alt>y" ]; 
    };

    # Virtualization
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };  
}