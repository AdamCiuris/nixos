{ config, pkgs, ... }:{
  services.usbmuxd = {
    package= pkgs.unstable.usbmuxd2;
    user = "usbmux"; # default is "usbmux"
    group = "usbmux";
    enable = true;
  };
}