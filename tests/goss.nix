{ config, pkgs, ... }:

let
  # 1. Define the Goss YAML declaratively
  goss-bios-config = pkgs.writeText "goss-bios.yaml" ''
    file:
      /dev/kvm:
        exists: true
        filetype: character-device
        owner: root
        group: kvm

    command:
      # Check that CPU virtualization extensions are active
      check_cpu_virt:
        exec: "${pkgs.util-linux}/bin/lscpu | grep -i 'Virtualization'"
        exit-status: 0
        stdout:
          - /Virtualization:\s+(VT-x|AMD-V)/

      # Run the comprehensive libvirt host validation
      validate_libvirt:
        exec: "${pkgs.libvirt}/bin/virt-host-validate qemu"
        exit-status: 0

    kernel-module:
      kvm:
        loaded: true
  '';

in
{
  # 2. Ensure testing tools are available system-wide
  environment.systemPackages = with pkgs; [ 
    goss 
    libvirt
    util-linux
  ];

  # 3. Create the systemd service to run Goss on boot
  systemd.services.goss-bios-check = {
    description = "Validate BIOS and Hardware State via Goss";
    wantedBy = [ "multi-user.target" ];
    # Ensure device nodes are populated before testing
    after = [ "systemd-udevd.service" ]; 
    
    serviceConfig = {
      Type = "oneshot";
      # Run goss validate. The '--format documentation' flag makes the journalctl output highly readable.
      ExecStart = "${pkgs.goss}/bin/goss -g ${goss-bios-config} validate --format documentation";
      # Don't restart if it fails, just leave it in a failed state for you to inspect
      RemainAfterExit = true; 
    };
  };
}