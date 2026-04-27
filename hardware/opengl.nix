{ config, pkgs, ... }:
{
  # Enable OpenGL
services.xserver.videoDrivers = [ "nvidia" ];

hardware.graphics.enable =  true;
# hardware.opengl.driSupport = true;
# hardware.graphics.driSupport32Bit = true; # Needed for Steam/Wine

# Load nvidia driver for Xorg and Wayland
# services.xserver.videoDrivers = ["nvidia"];

  # 4. NVIDIA Specific Driver Configuration
  hardware.nvidia = {
    # Guard against screen tearing
    modesetting.enable = true;
    
    # CRITICAL: Pascal GPUs (GTX 1070) DO NOT support the open module
    open = false; 

    # Enable the Nvidia settings menu applet
    nvidiaSettings = true;

    # Use the reliable stable production driver
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Optionally, you may need to select the appropriate driver version
  # For 10-series cards, the production branch is recommended
# Updates CPU microcode for security and stability
  hardware.cpu.intel.updateMicrocode = true;

}