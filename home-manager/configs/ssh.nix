{ config, pkgs, ... }: {
  programs.ssh = { 
    enable = true;
    enableDefaultConfig = false;
    
    settings = {
      "github.com" = {
        HostName = "github.com";
        IdentityFile = "~/.ssh/id_ed25519_github";
      };

      # 1. Define the local VM Jump Host explicitly
      "127.0.0.1" = {
        Port = "2222";
        User = "root";
        IdentityFile = "~/.ssh/id_ed25519_ts";
        IdentitiesOnly = "yes";
        StrictHostKeyChecking = "no";
        UserKnownHostsFile = "/dev/null";
      };

      # 2. Catch-all for any raw Tailscale IP you type in the terminal
      "100.*" = {
        ProxyJump = "127.0.0.1";
      };

      # 3. Your specific laptop config
      "nyx-asus-laptop" = {
        HostName = "100.81.2.91"; # See note below about this TODO
        User = "nyx";
        # Replaced the old nc ProxyCommand with the VM ProxyJump
        ProxyJump = "127.0.0.1";
      };
      
      "gce-builder" = {
        HostName = "nixos-builder-e2-8vpu-4core-32gb-100diskgb";
        User = "adamciuris_gmail_com";
        IdentityFile = "/home/nyx/.ssh/google_compute_engine";
        ProxyCommand = "gcloud compute start-iap-tunnel %h %p --listen-on-stdin --zone=us-central1-f --project=home-lab-in-quotes";
        ControlMaster = "auto";
        ControlPath = "/home/nyx/.ssh/master-%r@%h:%p";
        ControlPersist = "10m";
        
        StrictHostKeyChecking = "no";
        ServerAliveInterval = "15";
        ServerAliveCountMax = "5";
        IPQoS = "none";
      };
    };
  };
}