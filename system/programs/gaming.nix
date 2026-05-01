{ config, pkgs, ... }:

{
  networking.firewall = {
    enable = true;
    # Steam Link standard: UDP 27031, 27036 | TCP 27036, 27037
    # Steam Link VR-Specific: UDP 10400, 10401
    # Note: Port 9757 is automatically opened by services.wivrn.openFirewall
    allowedTCPPorts = [ 27036 27037 5555 9757 5353 ]; 
    allowedUDPPorts = [ 27031 27036 10400 10401 9757];
  };
  # env PRESSURE_VESSEL_FILESYSTEMS_RW="$XDG_RUNTIME_DIR/wivrn/comp_ipc" %command% -vrmode openxr
services.wivrn = {
  enable = true;
  openFirewall = true;

  # Run WiVRn as a systemd service on startup
  autoStart = true;

  # If you're running this with an nVidia GPU and want to use GPU Encoding (and don't otherwise have CUDA enabled system wide), you need to override the cudaSupport variable.
  package = (pkgs.unstable.wivrn.override { cudaSupport = true; });

  # You should use the default configuration (which is no configuration), as that works the best out of the box.
  # However, if you need to configure something see https://github.com/WiVRn/WiVRn/blob/master/docs/configuration.md for configuration options and https://mynixos.com/nixpkgs/option/services.wivrn.config.json for an example configuration.
};

  # services.wivrn.steam.importOXRRuntimes = true;

  # programs.envision.openFirewall = true;

  hardware.graphics.extraPackages = with pkgs.unstable; [
    libva-vdpau-driver
    libvdpau-va-gl
  ];
  programs.adb.enable = true;
  # users.users.nyx.extraGroups = [ "adbusers" "video" "render"];
  
  # security.rtkit.enable = true;

  environment.systemPackages = with pkgs.unstable; [
    android-tools
  ];

  programs.steam = {
    enable = true;
    package = pkgs.unstable.steam; # Force Steam to use the unstable package
    gamescopeSession.enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  programs.gamemode.enable = true;
}