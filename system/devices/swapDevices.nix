{ config, pkgs, ... }:

let
  # Create the toggle script
  toggle-zram = pkgs.writeShellScriptBin "toggle-zram" ''
    # Check if a zram swap device is currently active
    if grep -q "^/dev/zram" /proc/swaps; then
      # Find the active device (e.g., /dev/zram0)
      ZRAM_DEV=$(grep "^/dev/zram" /proc/swaps | awk '{print $1}')
      
      # Disable it
      sudo /run/current-system/sw/bin/swapoff "$ZRAM_DEV"
      sudo /run/current-system/sw/bin/zramctl --reset "$ZRAM_DEV"
      
      ${pkgs.libnotify}/bin/notify-send "zRAM Disabled" "Swap removed from $ZRAM_DEV"
    else
      # Load the kernel module
      sudo /run/current-system/sw/bin/modprobe zram
      
      # Calculate 50% of total RAM in Megabytes dynamically
      TOTAL_MEM=$(free -m | awk '/^Mem:/{print $2}')
      ZRAM_SIZE=$((TOTAL_MEM / 2))M
      
      # Initialize the device with zstd compression
      ZRAM_DEV=$(sudo /run/current-system/sw/bin/zramctl --find --size "$ZRAM_SIZE" --algorithm zstd)
      
      # Format and enable swap
      sudo /run/current-system/sw/bin/mkswap "$ZRAM_DEV"
      sudo /run/current-system/sw/bin/swapon --priority 100 "$ZRAM_DEV"
      
      ${pkgs.libnotify}/bin/notify-send "zRAM Enabled" "Allocated $ZRAM_SIZE on $ZRAM_DEV"
    fi
  '';
in
{
  # Keep your existing sysctl optimizations
  boot.kernel.sysctl = {
    "vm.swappiness" = 100;
    "vm.vfs_cache_pressure" = 50;
    "vm.watermark_scale_factor" = 125;
    "vm.page-cluster" = 0; 
  };

  # 1. Add the custom toggle script and libnotify (for visual desktop notifications)
  environment.systemPackages = with pkgs; [
    toggle-zram
    libnotify
  ];

  # 2. Allow your user to run the underlying commands without a password prompt
  # security.sudo.extraRules = [
  #   {
  #     users = [ "nyx" ]; # <--- IMPORTANT: Change this to your actual Linux username!
  #     commands = [
  #       { command = "/run/current-system/sw/bin/zramctl"; options = [ "NOPASSWD" ]; }
  #       { command = "/run/current-system/sw/bin/mkswap"; options = [ "NOPASSWD" ]; }
  #       { command = "/run/current-system/sw/bin/swapon"; options = [ "NOPASSWD" ]; }
  #       { command = "/run/current-system/sw/bin/swapoff"; options = [ "NOPASSWD" ]; }
  #       { command = "/run/current-system/sw/bin/modprobe"; options = [ "NOPASSWD" ]; }
  #     ];
  #   }
  # ];
}