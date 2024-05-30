{ config, pkgs, ... }:
{
  services.nginx.enable = true;
  services.nginx.virtualHosts."myhost.org" = {
    listen= [
      {
        addr="127.0.0.1";
        port = 80;
        }
      ];
    serverName = "127.0.0.1";
    locations."/".proxyPass = "http://unix:/run/gunicorn.sock";
    locations."/static/".root = "/home/nyx/GITHUB/portfolio-website/";
    # locations."/".proxyPass = "http://unix:/run/gunicorn.sock";

      # addSSL = true;
      # enableACME = true;
      # root = "/var/www/myhost.org";
  };
  # security.acme = {
  #   acceptTerms = true;
  #   defaults.email = "foo@bar.com";
  # };
}