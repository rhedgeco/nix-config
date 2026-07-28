{
  lib,
  den,
  ...
}: {
  # define a user schema item that allows for setting as primary user
  den.schema.user = {
    options.primary = lib.mkEnableOption "Make user the primary system user";
  };

  # create an aspect that includes the primary user if primary schema is enabled
  den.aspects.set-primary = {user, ...}:
    lib.optional (user.primary) {
      includes = [den.batteries.primary-user];
    };

  # include the set primary aspect by default
  den.default.includes = [den.aspects.set-primary];
}
