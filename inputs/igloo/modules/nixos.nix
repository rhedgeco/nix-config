{lib, ...}: {
  imports = [./global.nix];

  options.igloo.home = lib.mkOption {
    description = "Configuration to apply to every igloo user";
    type = lib.types.attrs;
    default = {};
  };
}
