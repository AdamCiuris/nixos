{ config, pkgs, lib, ... }:

let
  vrcft-avalonia = pkgs.appimageTools.wrapType2 {
    name = "vrcfacetracking";
    src = pkgs.fetchurl {
      # Ensure you check dfgHiatus/VRCFaceTracking.Avalonia for the latest release URL
      url = "https://github.com/dfgHiatus/VRCFaceTracking.Avalonia/releases/download/v1.0.0/VRCFaceTracking-Linux.AppImage"; 
      hash = lib.fakeHash; # Update with actual hash via `nix run nixpkgs#nix-prefetch-url`
    };
    extraPkgs = pkgs: with pkgs; [ 
      icu 
      openssl 
      zlib 
    ];
  };
in
{
  # 1. Enable iOS USB daemon for direct wired connections (reduces tracking latency)
  services.usbmuxd.enable = true;

  # 2. Open UDP ports for OSC and iPhone Tracking Apps
  networking.firewall.allowedUDPPorts = [
    49983 # iFacialMocap
    11111 # Unreal Live Link Face
    9000  # VRChat OSC Receive
    9001  # VRChat OSC Send
  ];

  # Optional: Static IP for direct Ethernet adapter to the iPhone
  # networking.interfaces."enpXsY".ipv4.addresses = [{
  #   address = "192.168.2.10";
  #   prefixLength = 24;
  # }];

  # 3. Add the packaged application to your environment
  environment.systemPackages = [ vrcft-avalonia ];
}