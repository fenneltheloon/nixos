{ config, lib, ... }:

{
  fileSystems."/home" = {
    device = "/dev/disk/by-label/NIXHOME";
    fsType = "btrfs";
  };
}
