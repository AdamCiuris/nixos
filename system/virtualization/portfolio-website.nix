{ config, pkgs, ... }:
let 
  webPort = 8081;
  serverPort = 8082;
in
{
  virtualisation.oci-containers = {
    backend = "docker"; # Use Docker as the backend
    containers.port-website = {
      image = "ubuntu/nginx";
      ports = [ "${builtins.toString webPort}:8081" "${builtins.toString serverPort}:8082"];
      volumes = [ "/etc/nixos/system/virtualization/configs/portfolio-website/:/portfolio-website/" ];
      # entrypoint = "/usr/sbin/nginx";
      cmd = ["nginx" "-c" "/portfolio-website/nginx.conf" "-p" "/portfolio-website"];
      extraOptions = [ 
        "--add-host=host.docker.internal:host-gateway"
       ];
      # restartPolicy = "always";
    };
  };
  networking.firewall.allowedTCPPorts = [ 
    webPort
    serverPort
    ];
  # services.nginx.virtualHosts."ciuris.xyz" = {
  #   listen= [
  #     {
  #       addr="127.0.0.1";
  #       port = 5454;
  #       }
  #     ];
  #   serverName = "127.0.0.1";
  #   locations."/".proxyPass = "http://unix:/run/gunicorn.sock";
  #   locations."/static/".root = "/home/nyx/GITHUB/portfolio-website/";
  #   # locations."/".proxyPass = "http://unix:/run/gunicorn.sock";

  #     # addSSL = true;
  #     # enableACME = true;
  #     # root = "/var/www/myhost.org";
  # };
  # security.acme = {
  #   acceptTerms = true;
  #   defaults.email = "foo@bar.com";
  # };
}