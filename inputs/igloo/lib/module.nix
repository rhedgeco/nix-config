{lib, ...}: let
  module = {
    name,
    enable ? false,
    global ? {},
    nixos ? {},
    user ? {},
  }: let
    # create and apply defaults to config variants
    default = {
      imports ? [],
      options ? {},
      config ? {},
    }: {inherit imports options config;};
    moduleGlobal = default global;
    moduleNixos = default nixos;
    moduleUser = default user;
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
        imports = moduleGlobal.imports;
        options.igloo.module."${name}" = moduleGlobal.options;
        config = lib.mkIf config.igloo.module."${name}".enable moduleGlobal.config;
      })

      # import a module that changes configuration based on iglooTarget
      ({
        config,
        iglooTarget ? "unknown",
        ...
      }: let
        isUser = iglooTarget == "user";
        isNixos = iglooTarget == "nixos";
      in {
        imports =
          if isNixos
          then moduleNixos.imports
          else if isUser
          then moduleUser.imports
          else {};

        options.igloo.module."${name}" =
          if isNixos
          then moduleNixos.options
          else if isUser
          then moduleUser.options
          else {};

        config = lib.mkIf config.igloo.module."${name}".enable (
          if isNixos
          then moduleNixos.config
          else if isUser
          then moduleUser.config
          else {}
        );
      })
    ];
  };
in {
  inherit module;
}
