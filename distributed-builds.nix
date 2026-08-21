{ config, pkgs, lib, ... }:
{
  environment.systemPackages = with pkgs; [
  google-cloud-sdk
  netcat-openbsd 
];
  # nix.settings.trusted-users = [ "root" "nyx" ]; # on asus-laptop
  # nix.settings.trusted-users = [ "root" "adamciuris_gmail_com" ]; # on gcloud
  nix = {
    distributedBuilds = true;
    # Optional: fallback to local build if builders are offline
    settings.builders-use-substitutes = true; 

    buildMachines = [
      {
        hostName = "nyx-asus-laptop";
        sshUser = "nyx";
        # sshKey = "/root/.ssh/id_ed25519"; # The key copied in Step 2
        system = "x86_64-linux"; # Change to aarch64-linux if it's an ARM laptop
        maxJobs = 4; # Adjust to the laptop's core count
        speedFactor = 1;
        supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
      }
      {
        hostName = "gce-builder";
        sshUser = "adamciuris_gmail_com";
        sshKey = "/root/.ssh/google_compute_engine";
        system = "x86_64-linux";
        maxJobs = 4; # Adjust based on the GCE instance
        speedFactor = 2; # Prioritize the GCE builder if it's faster
        supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
      }
    ];
  };
}