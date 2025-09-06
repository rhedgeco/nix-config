{
  lib,
  config,
  inputs,
  ...
}: {
  imports = [
    (lib.mkIf config.custom.options.home-manager.enable inputs.home-manager.nixosModules.home-manager)
  ];

  options.custom.home-manager = {
    enable = lib.mkEnableOption "Enable home manager";
  };

  config = lib.mkIf config.custom.options.home-manager.enable {
    home-manager = {
      useGlobalPkgs = true;
      extraSpecialArgs = {inherit inputs;};
    };
  };
}
