{ config, pkgs, lib, ... }:

{
  systemd.tmpfiles.rules = [
    "d /home/nyx/kavita/Books 0755 nyx users -"
    "d /var/lib/kavita 0755 nyx users -"
  ];

  # Strip the trailing newline so it doesn't break appsettings.json syntax
  system.activationScripts.kavitaToken = ''
    if [ ! -f /var/lib/kavita/token-key ]; then
      mkdir -p /var/lib/kavita
      head -c 64 /dev/urandom | base64 | tr -d '\n' > /var/lib/kavita/token-key
      chown nyx:users /var/lib/kavita/token-key
      chmod 600 /var/lib/kavita/token-key
    fi
  '';

  services.kavita = {
    enable = true;
    user = "nyx";
    tokenKeyFile = "/var/lib/kavita/token-key";
    settings = {
      Port = 5001;
      IpAddresses = "127.0.0.1";
    };
  };

  systemd.services.kavita.environment = {
    KAVITA_PORT = "5001";
  };
}