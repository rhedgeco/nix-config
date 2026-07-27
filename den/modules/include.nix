{
  lib,
  den,
  ...
}: {
  # allow users to specify includes at the entity level
  den.schema.host = {
    options.includes = lib.mkOption {
      type = with lib.types; listOf anything;
      default = [];
    };
  };

  # allow users to specify includes at the entity level
  den.schema.user = {
    options.includes = lib.mkOption {
      type = with lib.types; listOf anything;
      default = [];
    };
  };

  # allow standalone homes to specify includes at the entity level
  den.schema.home = {
    options.includes = lib.mkOption {
      type = with lib.types; listOf anything;
      default = [];
    };
  };

  # create an aspect to pass the host schema includes to the module system
  den.aspects.host-schema-include = {host}: {
    includes = host.includes;
  };

  # create an aspect to pass the user schema includes to the module system
  den.aspects.user-schema-include = {user}: {
    includes = user.includes;
  };

  # create an aspect to pass the home schema includes to the module system
  den.aspects.home-schema-include = {home}: {
    includes = home.includes;
  };

  # include the *-schema-include aspects by default
  den.default.includes = [
    den.aspects.host-schema-include
    den.aspects.user-schema-include
    den.aspects.home-schema-include
  ];
}
