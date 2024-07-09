{ config, pkgs, ... }:
let 
  webPort = 3000;
in
{
  virtualisation.oci-containers = {
    backend = "docker"; # Use Docker as the backend
    containers.open-webui = {
      image = "ghcr.io/open-webui/open-webui:main";
      ports = [ "${webPort}:8080" ];
      volumes = [ "open-webui:/app/backend/data" ];
      extraOptions = [ "--add-host=host.docker.internal:host-gateway"
                        "OLLAMA_BASE_URL=http://127.0.0.1:65020"
       ];
      # restartPolicy = "always";
    };
  };
  networking.firewall.allowedTCPPorts = [ webPort ];
}
# docker run -d -p 3000:8080 --add-host=host.docker.internal:host-gateway -v open-webui:/app/backend/data --name open-webui --restart always ghcr.io/open-webui/open-webui:main