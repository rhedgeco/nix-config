{
  lib,
  den,
  ...
}:
{
  # define a user schema item that allows for setting as primary user
  den.schema.user = {
    options.primary = lib.mkEnableOption "Make user the primary system user";
  };

  den.aspects.schema-primary =
    { user, ... }:
    lib.optional (user.primary) {
      # include the primary user battery
      includes = [ den.batteries.primary-user ];

      # add the user to the trusted user group
      nixos.nix.settings.trusted-users = [ user.userName ];
    };

  # include the schema-primary aspect by default
  den.default.includes = [ den.aspects.schema-primary ];
}
