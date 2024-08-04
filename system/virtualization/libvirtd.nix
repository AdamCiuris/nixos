{ config, pkgs, ... }:
{
  virtualisation.libvirtd.enable = true;
  programs = {
    virt-manager.enable = true;
  };
}
# note tags: mapping disks, mounting disks in kvm, mount disk
# below will mount real sata drive in qemu/kvm stuff
# https://askubuntu.com/questions/144894/add-physical-disk-to-kvm-virtual-machine
# <disk type="block" device="disk">
#   <driver name="qemu" type="raw"/>
#   <source dev="/dev/sda"/>
#   <target dev="vda" bus="sata"/>
#   <address type="drive" controller="0" bus="0" target="0" unit="2"/>
# </disk>