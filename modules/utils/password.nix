{
  lib,
  den,
  ...
}:
{
  # define a user schema item that allows for setting the user password
  den.schema.user = {
    options.password = lib.mkOption {
      description = "Sets the initial user password";
      type = with lib.types; nullOr str;
      default = null;
    };
  };

  # create an aspect that sets the intial user password if it is not null
  den.aspects.schema-password =
    { user, ... }:
    lib.optional (user.password != null) {
      nixos.users.users.${user.name}.initialPassword = user.password;
    };

  # include the schema password aspect by default
  den.default.includes = [ den.aspects.schema-password ];
}
