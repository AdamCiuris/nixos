{ config, pkgs, lib, modulesPath, ... }: 
{
  imports= [./myxrdp.nix ];
  services.xrdp = {
      enable = true;
      defaultWindowManager = "xfce4-session";
      confDir = "$out";
#       extraConfDirCommands= ''
#   substituteInPlace $out/sesman.ini \
#     --replace LogLevel=INFO LogLevel=DEBUG \
#     --replace LogFile=/dev/null LogFile=/var/log/xrdp.log
# '';
      port = "tcp://:8181";
      # openFirewall=true; # https://c-nergy.be/blog/?p=14965/
    };
    networking.enableIPv6 = lib.mkForce false; # ipv4 only pls

    environment.systemPackages = [
      pkgs.xrdp
    ];
}