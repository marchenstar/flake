{
  lib,
  config,
  pkgs,
  homeManagerModules,
  ...
}:

{
  imports = [
    ./violet.nix
    homeManagerModules.plasma
    homeManagerModules.generic
  ];
  services.syncthing.enable = true;
  home.packages = [
    pkgs.nixgl.nixVulkanIntel
    pkgs.nixgl.nixGLIntel
  ];
  home.stateVersion = "24.05";
}
