{ pkgs, ... }:
let
  username = "megumin";
in
{
  home = {
    inherit username;
    homeDirectory = "/home/${username}";
  };
  imports = [
    ./base.nix
  ];

  home.packages = with pkgs; [
    fanbox-dl
  ];
  home.stateVersion = "24.05";
}
