{lib, ...}: let
  userModule = {
    name,
    enable ? false,
    imports ? [],
    options ? {},
    config ? {},
  }:
    module {
      inherit name enable;
      user = {inherit imports options config;};
    };

  nixosModule = {
    name,
    enable ? false,
    imports ? [],
    options ? {},
    config ? {},
  }:
    module {
      inherit name enable;
      nixos = {inherit imports options config;};
    };

  module = {
    name,
    enable ? false,
    global ? {},
    nixos ? {},
    user ? {},
  }: let
    # create a function that generates a module for a specific iglooTarget
    buildTargetModule = {
      target,
      imports,
      options,
      config,
    }: let
      targetImports = imports;
      targetOptions = options;
      targetConfig = config;
    in ({
      config,
      iglooTarget ? "unknown",
    }:
      if iglooTarget == target
      then {
        imports = targetImports;
        options.igloo.module."${name}" = targetOptions;
        config = lib.mkIf config.igloo.module."${name}".enable targetConfig;
      }
      else {});
  in {
    # create the enable option for this igloo module
    options.igloo.module."${name}" = {
      enable = lib.mkOption {
        type = lib.types.bool;
        description = "Enables the '${name}' igloo module.";
        default = enable;
      };
    };

    imports = [
      # import a module that applies all global values
      ({config, ...}: {
        imports = global.imports or [];
        options.igloo.module."${name}" = global.options or {};
        config = lib.mkIf config.igloo.module."${name}".enable (global.config or {});
      })

      # import a module that applies all nixos config if applicable
      (buildTargetModule {
        target = "nixos";
        imports = nixos.imports or [];
        options = nixos.options or {};
        config = nixos.config or {};
      })

      # import a module that applies all user config if applicable
      (buildTargetModule {
        target = "user";
        imports = user.imports or [];
        options = user.options or {};
        config = user.config or {};
      })
    ];
  };
in {
  inherit module userModule nixosModule;
}
