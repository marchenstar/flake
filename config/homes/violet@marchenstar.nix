{
  lib,
  config,
  pkgs,
  homeManagerModules,
  mylib,
  ...
}:

let
  nixglPackage = pkgs.nixgl.override {
    "enable32bits" = false;
    intel-media-driver = pkgs.intel-vaapi-driver;
  };
  wrapIntelGL = mylib.wrapPrefix nixglPackage.nixGLIntel;
  wrapIntelVulkan = mylib.wrapPrefix nixglPackage.nixVulkanIntel;
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
    (wrapIntelGL pkgs.moonlight-qt "moonlight")
  ];
  home.stateVersion = "24.05";
}
