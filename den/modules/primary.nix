{
  lib,
  den,
  ...
}: {
  # define a user schema item that allows for setting as primary user
  den.schema.user = {
    options.primary = lib.mkEnableOption "Make user the primary system user";
  };

  # when the user is set as primary, include the primary-user battery
  den.default.includes = [
    ({user, ...}: {includes = lib.optional (user.primary) [den.batteries.primary-user];})
  ];
}
