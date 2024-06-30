{ config, pkgs, ... }:{
  services.usbmuxd = {
    user = "usbmux"; # default is "usbmux"
    group = "usbmux";
    enable = true;
  };
}