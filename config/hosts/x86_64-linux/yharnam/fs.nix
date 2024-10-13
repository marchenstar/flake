{ lib, ... }:

{
  fileSystems."/" = {
    options = [
      "size=5%"
      "mode=0755"
    ];
  };
  fileSystems."/.bcachefs" = {
    device = lib.mkForce "/dev/disk/by-uuid/cd0c4d55-6bb1-4b3d-8ae0-7b27083ab3dc";
    fsType = "bcachefs";
    neededForBoot = true;
  };
  fileSystems."/nix" = {
    neededForBoot = true;
  };
  fileSystems."/var" = {
    neededForBoot = true;
  };
  fileSystems."/persist" = {
    neededForBoot = true;
  };
}
