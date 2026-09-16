{ config, pkgs, ... }:
{
    networking.wg-quick.interfaces.mullvad = {
    autostart = true;
    privateKeyFile = "/etc/wireguard/mullvad.key"; 
    
    # Replace with the Address values from your Mullvad .conf file
    address = [ 
      "10.65.124.59/32" 
    ];
    
    dns = [ "1.1.1.1" "8.8.8.8" ];    
    peers = [
      {
        # Replace with the PublicKey and Endpoint from your Mullvad .conf file
        publicKey = "BLNHNoGO88LjV/wDBa7CUUwUzPq/fO2UwcGLy56hKy4=";
        endpoint = "87.249.134.27:3152";
        allowedIPs = [ "0.0.0.0/0" "100.64.0.0/10" ];
      }
    ];
  };

}