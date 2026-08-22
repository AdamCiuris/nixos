{ config, lib, pkgs, ... }:
# https://www.youtube.com/watch?v=RGVt16xiERc

{
  # do not ever use a swapfile on low end machines
  # Remove or comment out the physical swapfile
  # swapDevices = [ { device = "/__swapfile__"; ... } ];

  # Enable compressed RAM swap
  zramSwap = {
    enable = true;
    memoryPercent = 50; # Creates a zram device up to 50% of your total RAM
  };

  boot.kernel.sysctl = {
    # zram is fast; encourage the kernel to use it proactively
    "vm.swappiness" = 100;
    
    # Keep metadata cached
    "vm.vfs_cache_pressure" = 50;
    
    # Wake up the background paging daemon earlier
    "vm.watermark_scale_factor" = 125;
    
    # Optimize page clustering for zram
    "vm.page-cluster" = 0; 
  };
}