{
  lib,
  config,
  pkgs,
  homeManagerModules,
  mylib,
  ...
}:

let
  wrapIntelGL = mylib.wrapPrefix pkgs.nixgl.nixGLIntel;
  wrapIntelVulkan = mylib.wrapPrefix pkgs.nixgl.nixVulkanIntel;
in
{
  imports = [
    ./violet.nix
    homeManagerModules.plasma
    homeManagerModules.generic
  ];
  services.syncthing.enable = true;
  home.packages = [
    (wrapIntelVulkan pkgs.zed-editor "zeditor")
  ];
  home.stateVersion = "24.05";
}
