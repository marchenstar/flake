{
  config,
  lib,
  secrets,
  ...
}:
let
  defaultNetwork = "10-default";
  nicAddress = "pci-0000:29:00.0";
in
{
  systemd.network.enable = true;
  systemd.network.networks = {
    "${defaultNetwork}" = {
      matchConfig.Path = "${nicAddress}";
      networkConfig = {
        DHCP = "ipv4";
        DNSOverTLS = "no";
      };
    };
  };
  sops.secrets."net/yharnam/ipv6" = {
    reloadUnits = [
      "systemd-networkd.service"
      "nftables.service"
    ];
  };
  sops.templates."yharnam/ipv6" = {
    content = lib.generators.toINI { } {
      Network = {
        Address = "${config.sops.placeholder."net/yharnam/ipv6"}";
        Gateway = "fe80::1";
      };
    };
    path = "/etc/systemd/network/${defaultNetwork}.network.d/ipv6.conf";
    group = "systemd-network";
    mode = "0444";
  };
  sops.secrets."ssh/initrd_host_key" = {
    sopsFile = secrets.yharnam;
    mode = "0600";
  };
  boot.initrd = {
    availableKernelModules = [
      "igb"
    ];
    systemd.network.enable = true;
    systemd.network.networks.${defaultNetwork} = config.systemd.network.networks.${defaultNetwork};
    network = {
      enable = true;
      ssh = {
        enable = true;
        authorizedKeys = [
          "cert-authority ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAION8+4aF6hbXO1QxU5GqvZZHZWThD6MAiLcWq+bPSWD8 Gwen User CA"
        ];
        extraConfig = ''
          HostKey /etc/ssh/ssh_host_ed25519_key
        '';
        ignoreEmptyHostKeys = true;
      };
    };
    secrets = {
      "/etc/ssh/ssh_host_ed25519_key" = config.sops.secrets."ssh/initrd_host_key".path;
    };
  };
}
