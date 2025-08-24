{
  lib,
  modulesPath,
  ...
}: {
  imports = [
    # always import not-detected to add useful kernel modules
    (modulesPath + "/installer/scan/not-detected.nix")
    ./framework.nix
  ];

  options.custom.hardware = {
    enable = lib.mkOption {
      type = lib.types.enum ["framework"];
      description = "Select hardware configuration for this system.";
    };
  };
}
