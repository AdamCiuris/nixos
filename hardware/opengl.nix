{ config,lib, pkgs, ... }:
{
  # Enable OpenGL
services.xserver.videoDrivers = [ "nvidia" ];

hardware.graphics.enable =  true;
# hardware.opengl.driSupport = true;
# hardware.graphics.driSupport32Bit = true; # Needed for Steam/Wine

# Load nvidia driver for Xorg and Wayland
# services.xserver.videoDrivers = ["nvidia"];
              hardware.nvidia = {
  package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
    version = "580.142"; # Replace with your exact 580 patch version target
    sha256_64bit = "sha256-IJFfzz/+icNVDPk7YKBKKFRTFQ2S4kaOGRGkNiBEdWM=";
    # sha256_aarch64 = "sha256-BnrIlj5AvXTfqg/qcBt2OS9bTDDZd3uhf5jqOtTMTQM=";
    openSha256 = "sha256-JnrIlj5AvXTfqg/qcBt2OS9bTDDZd3uhf5jqOtTMTQM=";
    # settingsSha256 = "sha256-BnrIlj5AvXTfqg/qcBt2OS9bTDDZd3uhf5jqOtTMTQM=";
    settingsSha256 = "sha256-BnrIlj5AvXTfqg/qcBt2OS9bTDDZd3uhf5jqOtTMTQM=";
    persistencedSha256 = "sha256-CnrIlj5AvXTfqg/qcBt2OS9bTDDZd3uhf5jqOtTMTQM=";
  };
};
  # 4. NVIDIA Specific Driver Configuration
  hardware.nvidia = {
    # Guard against screen tearing
    modesetting.enable = true;
    
    # CRITICAL: Pascal GPUs (GTX 1070) DO NOT support the open module
    open = false; 

    # Enable the Nvidia settings menu applet
    nvidiaSettings = true;

    # Use the reliable stable production driver
    # package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Optionally, you may need to select the appropriate driver version
  # For 10-series cards, the production branch is recommended
# Updates CPU microcode for security and stability
  hardware.cpu.intel.updateMicrocode = true;

}