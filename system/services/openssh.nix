{ config, pkgs, ... }:
{
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no"; # Keep your original value ("yes", "no", "prohibit-password", etc.)
      PasswordAuthentication = false; # Keep your original boolean value
    };
  };
}