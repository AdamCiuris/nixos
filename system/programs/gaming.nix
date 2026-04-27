{ config, pkgs, ... }:
# https://www.youtube.com/watch?v=qlfm3MEbqYA
{
networking.firewall = {
  enable = true;
  # Steam Link standard: UDP 27031, 27036 | TCP 27036, 27037
  # Steam Link VR-Specific: UDP 10400, 10401
  allowedTCPPorts = [ 27036 27037 ];
  allowedUDPPorts = [ 27031 27036 10400 10401 ];
};
services.wivrn = {
  enable = true;
  openFirewall = true;

  # Run WiVRn as a systemd service on startup
  autoStart = true;

  # If you're running this with an nVidia GPU and want to use GPU Encoding (and don't otherwise have CUDA enabled system wide), you need to override the cudaSupport variable.
  package = (pkgs.wivrn.override { cudaSupport = true; });

  # You should use the default configuration (which is no configuration), as that works the best out of the box.
  # However, if you need to configure something see https://github.com/WiVRn/WiVRn/blob/master/docs/configuration.md for configuration options and https://mynixos.com/nixpkgs/option/services.wivrn.config.json for an example configuration.
};
security.wrappers.wivrn = {
  owner = "root";
  group = "root";
  capabilities = "cap_sys_nice+ep";
  source = "${config.services.wivrn.package}/bin/wivrn-server";
};
  hardware.graphics.extraPackages = with pkgs; [
    libva-vdpau-driver
    libvdpau-va-gl
  ];
  
  # 1. Enable the ADB module
  programs.adb.enable = true;

  # 2. Add your user to the 'adbusers' group 
  users.users.nyx.extraGroups = [ "adbusers" ];

  # 3. (Optional) Add the tools to your system packages
  environment.systemPackages = with pkgs; [
    android-tools
  ];
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };
  programs.gamemode.enable = true;
  security.wrappers.steamvr = {
    owner = "nyx"; # Replace with your actual username
    group = "users";        # Usually "users", but check your group if you have a custom setup
    # source = "${pkgs.steam}/bin/steam-runtime-fixup";
    capabilities = "CAP_SYS_NICE+ep";
    # OR RUN THIS
    # sudo setcap CAP_SYS_NICE=eip ~/.local/share/Steam/steamapps/common/SteamVR/bin/linux64/vrcompositor-launcher

    # We use the 'lib.getExe' or direct path to the actual steam binary 
    # or the specific VR helper required by your setup.
    source = "${pkgs.steam}/bin/steam"; 
    # setuid = true;
  };
}