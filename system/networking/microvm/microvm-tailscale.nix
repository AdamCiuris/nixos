{ config, pkgs, ... }:

{
  microvm.vms."tailscale-vm".config = {
    system.stateVersion = "26.05"; 
    services.getty.autologinUser = "root";
    microvm.shares = [
      {
        source = "/var/lib/microvms/secrets"; # Host path
        mountPoint = "/run/secrets";          # VM path
        tag = "vm-secrets";
        proto = "9p";
      }
    ];
    # Authorize your host machine's public key for passwordless login
    users.users.root.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKPpADlS0ygwT0SvAeTPHmLpA8WEi9IlHtYQKxKkTVhE nyx@nixos"
    ];

    microvm.forwardPorts = [
      {
        from = "host";
        host.port = 2222;
        guest.port = 22;
      }
    ];

    # Enable SSH in the VM to act as the proxy
    services.openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "yes";
      };
    };

    # 1. Minimal Networking (User-mode / SLIRP)
    microvm.interfaces = [
      {
        type = "user";
        id = "qemu";
        mac = "02:00:00:00:00:01";
      }
    ];
    networking.useDHCP = true;
    
    # 2. Tailscale Service
    services.tailscale = {
      enable = true;
      authKeyFile = "/run/secrets/tailscale-key";
      extraUpFlags = [ "--ssh" ];
    };
  };
}