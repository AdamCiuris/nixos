{ config, pkgs,  ... }: 
{
  nix.settings = {
  substituters = [
    "https://cache.nixos.org"
    "https://cache.nixos-cuda.org" # cudatoolkit binaries
  ];
  trusted-public-keys = [ "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M=" ];
  };
}
# substituters = [
#   # Option A: SSH over Tailscale
#   # "ssh://nyx-asus-laptop" 
  
#   # Option B: HTTP over Tailscale (Requires nix-serve or harmonia)
#   "http://nyx-asus-laptop:5000" 
# ];

# trusted-public-keys = [
#   "nyx-asus-laptop-1:/home/nyx/version_controlled/nixos/pubkey.pem"
# ];