{ config, pkgs, ... }: 
let 
  portToConnectTo = 80;
in
{
  services.nix-serve = {
    enable = true;
    secretKeyFile = "/var/cache-priv-key.pem"; # https://nixos.wiki/wiki/Nixpkgs/Create_and_debug_packages
    port = 34543;
    openFirewall = true;
  };

    	networking.firewall =  {
        allowedTCPPorts = [  portToConnectTo  ]; 
        };
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    virtualHosts = {
      # ... existing hosts config etc. ...
      "cache.sirius.com" = {
        locations."/".proxyPass = "http://${config.services.nix-serve.bindAddress}:${toString config.services.nix-serve.port}";
        # listen= [
        #   {
        #     addr="0.0.0.0";
        #     port = portToConnectTo;
        #   }
        # ];
      };
    };
};
}