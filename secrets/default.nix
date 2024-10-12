{
  common = ./common.yaml;
  yharnam = ./yharnam.yaml;
  # wifi = builtins.map (x: ./pc.yaml/wifi/${x}) (
  #   builtins.attrNames (builtins.fromJSON (builtins.readFile ./pc.json)).wifi
  # );
}
