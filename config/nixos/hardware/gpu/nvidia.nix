{
  config,
  lib,
  modules,
  ...
}:

{
  imports = [
    modules.nixos.unfree
  ];
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    open = true;
    nvidiaSettings = true;
    package = lib.mkDefault config.boot.kernelPackages.nvidiaPackages.latest;
  };
  unfree.packageList = [
    "nvidia-settings"
    "nvidia-x11"
  ];
  boot.kernelModules = [
    "nvidia"
    "nvidia-modeset"
    "nvidia-drm"
    "nvidia-uvm"
  ];
}
