{
  config,
  lib,
  pkgs,
  inputs,
  modules,
  systemName,
  ...
}:

let
  users = [ "violet" ];
in
{
  imports = [
    ./hardware-configuration.nix
    modules.nixos.builders.default
    modules.nixos.hardware.amd
    modules.nixos.hardware.gpu.nvidia
    modules.nixos.lanzaboote.default
    modules.nixos.home-manager
    modules.nixos.desktop.plasma
    modules.nixos.net.networkd-wifi
    modules.nixos.qemu
    inputs.disko.nixosModules.default
    modules.disko.luks-btrfs
    modules.nixos.steam
    inputs.self.nixosModules.services.OpenLinkHub
  ] ++ builtins.map (user: modules.nixos.users.${user}) users;
  home-manager.users = lib.genAttrs users (user: modules.homes."${user}@${systemName}");
  # ethernet device
  boot.kernelPackages = pkgs.linuxPackages_testing;
  hardware.nvidia.package =
    let
      patchesOpen = [
        (pkgs.fetchpatch {
          url = "https://raw.githubusercontent.com/CachyOS/CachyOS-PKGBUILDS/refs/heads/master/nvidia/nvidia-utils/0004-Fix-for-6.12.0-rc1-drm_mode_config_funcs.output_poll.patch";
          hash = "sha512-eyQ1sx7XM8AP9I27WLe3iFJkMI6r8h8+BNqfAOgZ8aFiNF6cZgYo+plZidt7eHS+xA8sK7w2wsnudKGZzbFQPQ==";
        })
        # (pkgs.fetchpatch {
        #   url = "https://raw.githubusercontent.com/CachyOS/CachyOS-PKGBUILDS/refs/heads/master/nvidia/nvidia-utils/0006-silence-event-assert-until-570.patch";
        #   hash = "sha512-WHpmNlYaFob0O7G4USGpPQ3eWso6rYSGVRSb24Fwpw8yYrTjjvgRutxosMp53d7Y8RoYUYK8aJm7r2q07fAPtA==";
        # })
      ];
    in
    config.boot.kernelPackages.nvidiaPackages.mkDriver {
      inherit (config.boot.kernelPackages.nvidiaPackages.beta) version;
      sha256_64bit = "sha256-buvpTlheOF6IBPWnQVLfQUiHv4GcwhvZW3Ks0PsYLHo=";
      sha256_aarch64 = "sha256-aDVc3sNTG4O3y+vKW87mw+i9AqXCY29GVqEIUlsvYfE=";
      openSha256 = "sha256-/tM3n9huz1MTE6KKtTCBglBMBGGL/GOHi5ZSUag4zXA=";
      settingsSha256 = "sha256-H7uEe34LdmUFcMcS6bz7sbpYhg9zPCb/5AmZZFTx1QA=";
      persistencedSha256 = "sha256-hdszsACWNqkCh8G4VBNitDT85gk9gJe1BlQ8LdrYIkg=";
      inherit patchesOpen;
    };
  disko.devices.disk.root.device = "/dev/disk/by-path/pci-0000:09:00.0-nvme-1";
  programs.virt-manager.enable = true;
  hardware.bluetooth.enable = true;
  services.OpenLinkHub.package = inputs.self.packages.x86_64-linux.OpenLinkHub.override {
    nvidia = config.hardware.nvidia.package;
  };
  services.OpenLinkHub.enable = true;
  services.hardware.openrgb.enable = true;
  services.hardware.openrgb.package = pkgs.openrgb.overrideAttrs (prevAttrs: {
    version = "20241110";
    src = pkgs.fetchFromGitLab {
      owner = "CalcProgrammer1";
      repo = "OpenRGB";
      rev = "7a69aef99b6772005af469bf9b69f22fd83616d7";
      hash = "sha512-karAIFGvXMl/IKK7sTtTlR4y4Rx1YdlKqneCIP8B7kEgMBK3NwyUvO1mYjGC4JN7WFVWFbP9hBxhrA/pO1Zt8A==";
      leaveDotGit = true;
    };
    postPatch = ''
      substituteInPlace scripts/build-udev-rules.sh \
        --replace /usr/bin/env ${pkgs.coreutils-full}/bin/env
    '';
    nativeBuildInputs = prevAttrs.nativeBuildInputs ++ [ pkgs.git ];
  });
  boot.extraModulePackages = [ config.boot.kernelPackages.nct6687d ];
  system.stateVersion = "24.11";
}
