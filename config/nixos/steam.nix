{
  config,
  lib,
  pkgs,
  nixosConfig,
  ...
}:

{
  imports = [
    nixosConfig.unfree
  ];
  unfree.packageList = [
    "steam"
    "steam-original"
    "steam-run"
  ];
  programs.steam.enable = true;
  programs.steam.remotePlay.openFirewall = true;
  programs.steam.localNetworkGameTransfers.openFirewall = true;
  hardware.steam-hardware.enable = true;

}
