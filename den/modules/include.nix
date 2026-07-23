{lib, ...}: {
  # allow users to specify includes at the entity level
  den.schema.user = {
    options.includes = lib.mkOption {
      type = with lib.types; listOf anything;
      default = [];
    };
  };

  # allow users to specify includes at the entity level
  den.schema.host = {
    options.includes = lib.mkOption {
      type = with lib.types; listOf anything;
      default = [];
    };
  };

  # pass through user and host includes from entities
  den.default.includes = [
    ({user}: {includes = user.includes;})
    ({host}: {includes = host.includes;})
  ];
}
