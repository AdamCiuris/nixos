{ config, pkgs, ... }: {
  programs.ssh = { 
    enable = true;
    enableDefaultConfig = false;
    
    settings = {
      "github.com" = {
        HostName = "github.com";
        IdentityFile = "~/.ssh/id_ed25519_github";
      };
      "nyx-asus-laptop" = {
        HostName = "100.81.2.91"; # subject to change TODO find out some way to imperatively set this or change accordingly
        User = "nyx";
        ProxyCommand = "nc -X 5 -x 127.0.0.1:1055 %h %p";
      };
      
      "gce-builder" = {
        HostName = "nixos-builder-e2-8vpu-4core-32gb-100diskgb";
        User = "adamciuris_gmail_com";
        IdentityFile = "/home/nyx/.ssh/google_compute_engine";
        ProxyCommand = "gcloud compute start-iap-tunnel %h %p --listen-on-stdin --zone=us-central1-f --project=home-lab-in-quotes";
        ControlMaster = "auto";
        ControlPath = "/home/nyx/.ssh/master-%r@%h:%p";
        ControlPersist = "10m";
        
        # extraOptions are now placed directly alongside standard directives
        StrictHostKeyChecking = "no";
        ServerAliveInterval = "15";
        ServerAliveCountMax = "5";
        IPQoS = "none";
      };
    };
  };
}