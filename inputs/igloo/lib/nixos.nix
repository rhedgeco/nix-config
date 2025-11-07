{
  lib,
  iglib,
  ...
}: let
  nixosSystem = {
    system ? null,
    modules ? [],
    specialArgs ? {},
  }: let
    nixosArgs = {
      inherit modules;
      specialArgs =
        specialArgs
        // {
          inherit iglib;
          iglooTarget = "nixos";
        };
    };

    systemArg = lib.optionalAttrs (system != null) {inherit system;};
  in
    lib.nixosSystem (nixosArgs // systemArg);
in {
  inherit nixosSystem;
}
