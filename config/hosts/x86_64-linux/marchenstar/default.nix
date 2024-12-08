{
  lib,
  modules,
  inputs,
  ...
}:
let
  users = [ "kanata" ];
in

{
  imports = [
    ./hardware-configuration.nix
    ./net.nix
    modules.nixos.hardware.intel
    modules.nixos.lanzaboote.default
    modules.nixos.home-manager
    modules.nixos.users.kanata
    inputs.disko.nixosModules.default
    ./fs.nix
    inputs.self.nixosModules.services.hath
  ] ++ builtins.map (user: modules.nixos.users.${user}) users;
  home-manager.users = lib.genAttrs users (user: modules.homes."${user}");
  hardware.rasdaemon.enable = true;
  services.smartd.enable = true;
  time.timeZone = "UTC";
  i18n.defaultLocale = "en_GB.UTF-8";
  users.users.root.hashedPassword = "$y$j9T$N4d6f/0luo4g9pnrBMKTS.$2t7Z4LzizfFdDET/Ij8DjgJLm5kRlWSU1bdzWXqVbo4";
  services = {
    sysstat.enable = true;
    hath.enable = false;
  };
  system.stateVersion = "25.05";
}
