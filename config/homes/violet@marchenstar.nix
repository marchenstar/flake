{
  lib,
  config,
  pkgs,
  homeManagerConfig,
  mylib,
  ...
}:

let
  f1Kanata2x = pkgs.fetchurl {
    url = "https://i.idol.st/u/card/art/2x/186Konoe-Kanata-It-s-my-turn-next-UR-92PePZ.png";
    hash = "sha256-ZsE61EBIXGQBVP899LObmB75no3UA+Ic6aborT4zUJU=";
  };
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
    homeManagerConfig.plasma
    homeManagerConfig.generic
  ];
  programs.plasma.workspace.wallpaper = "${f1Kanata2x}";
  programs.plasma.configFile.kdeglobals.General.AccentColor = "166,100,160";
  services.syncthing.enable = true;
  home.packages = [
    (wrapIntelVulkan pkgs.zed-editor "zeditor")
    (wrapIntelGL pkgs.moonlight-qt "moonlight")
  ];
  home.stateVersion = "24.05";
}
