{ config, pkgs, lib, ... }:
{
  # --max-jobs 0
  # above option to nixos-rebuild build ensures that NONE 
  # of the nix store packages are built locally
  # works with nix develop --max-jobs 0, too
  environment.systemPackages = with pkgs; [
    google-cloud-sdk
    netcat-openbsd 
  ];

  # Inject the Tailscale proxy into the Nix daemon
  systemd.services.nix-daemon.environment = {
    http_proxy = "socks5h://127.0.0.1:1055";
    
    # CRITICAL: We only want the proxy for Tailscale IPs. 
    # Tell Nix to fetch official packages over your normal internet connection!
    no_proxy = "localhost,127.0.0.1,cache.nixos.org,cache.nixos-cuda.org,github.com,tarballs.nixos.org";
  };
  nix.settings = {
    extra-substituters = [
      "http://100.81.2.91:5000?priority=30" # remember that the ts auth key expires
      "https://cache.nixos-cuda.org"
    ];
    extra-trusted-public-keys = [
      "asus-laptop:D0dVckw0IxslbmwmBJ0492FQZQmT+A0aNDjSkA13QNg="
      "nixos-cuda.org-1:6QW64hjvwc93v5IX7jx10m+n5zGkK2i/r18bL3U5G/0="
    ];
    connect-timeout = 1;
  };

  #  sudo nixos-rebuild switch --flake .#pc \
  # --option substituters "https://cache.nixos.org https://cache.nixos-cuda.org" \
  # --option extra-trusted-public-keys "nixos-cuda.org-1:6QW64hjvwc93v5IX7jx10m+n5zGkK2i/r18bL3U5G/0="
  # nix.settings.trusted-users = [ "root" "nyx" "@wheel" ]; # on asus-laptop
  # nix = {
  #   distributedBuilds = true;
  #   # Optional: fallback to local build if builders are offline
  #   settings.builders-use-substitutes = true; 
  #   nix.buildMachines = [{
  #   hostName = "100.81.2.91";
  #   sshUser = "nyx";
  #   sshKey = "/home/nyx/.ssh/id_ed25519";
  #   system = "x86_64-linux";
  #   protocol = "ssh-ng";
  #   # Set this to the number of CPU cores you want to use on the Asus
  #   maxJobs = 8;
  #   supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
  # }];
}