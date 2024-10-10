{
  lib,
  nixosConfig,
  inputs,
  homes,
  ...
}:
let
  users = [ "megumin" ];
in

{
  imports = [
    ./hardware-configuration.nix
    ./fs.nix
    ./persist.nix
    ./creds.nix
    ./net.nix
    nixosConfig.hardware.amd
    nixosConfig.lanzaboote
    nixosConfig.home-manager
    nixosConfig.users.megumin
    nixosConfig.users.nixremote
    inputs.self.nixosModules.services.hath
  ] ++ builtins.map (user: nixosConfig.users.${user}) users;
  home-manager.users = lib.genAttrs users (user: homes."${user}");
  hardware.rasdaemon.enable = true;
  services.smartd.enable = true;
  time.timeZone = "UTC";
  i18n.defaultLocale = "en_GB.UTF-8";
  users.users.root.hashedPassword = "$y$j9T$N4d6f/0luo4g9pnrBMKTS.$2t7Z4LzizfFdDET/Ij8DjgJLm5kRlWSU1bdzWXqVbo4";
  services = {
    sysstat.enable = true;
    hath.enable = true;
  };
  system.stateVersion = "24.11";
}
