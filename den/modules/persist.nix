{
  den,
  lib,
  inputs,
  ...
}: let
  # import impermanence for a host if it defines a persist path
  impermanentHost = {host, ...}:
    lib.optionalAttrs (host.persist.path != null) {
      ${host.class} = {...}: {
        imports = [inputs.impermanence.nixosModules.impermanence];
      };
    };

  # import the home-manager impermanence module for standalone homes if it defines a persist path
  impermanentHome = {home, ...}:
    lib.optionalAttrs (home.persist.path != null) {
      ${home.class} = {...}: {
        imports = [inputs.impermanence.homeManagerModules.impermanence];
      };
    };

  # create a class that forwards a hosts persistent system paths to impermanence
  persistHost = {host, ...}: {aspect-chain, ...}:
    den.provides.forward {
      each = lib.optional (host.persist.path != null) host;
      fromClass = _: "persist-host";
      intoClass = _: host.class;
      intoPath = _: [
        "environment"
        "persistence"
        host.persist.path
      ];
      fromAspect = _: lib.head aspect-chain;
    };

  # create a class that forwards a users persistent home files to host impermanence
  persistUser = {
    host,
    user,
    ...
  }: {aspect-chain, ...}:
    den.provides.forward {
      each = lib.optional (user.persist && host.persist.path != null) user;
      fromClass = _: "persist-home";
      intoClass = _: host.class;
      intoPath = _: [
        "environment"
        "persistence"
        host.persist.path
        "users"
        user.userName
      ];
      fromAspect = _: lib.head aspect-chain;
    };

  # create a class that forwards a standalone home's persistent files to home-manager impermanence
  # this class name should match the one found in persistUser so that it picks up the same persist paths
  persistHome = {home, ...}: {aspect-chain, ...}:
    den.provides.forward {
      each = lib.optional (home.persist.path != null) home;
      fromClass = _: "persist-home";
      intoClass = _: home.class;
      intoPath = _: [
        "home"
        "persistence"
        home.persist.path
      ];
      fromAspect = _: lib.head aspect-chain;
    };
in {
  den.schema.host = {
    options.persist.path = lib.mkOption {
      description = "Path to persistent storage. Enables impermanence when set.";
      type = lib.types.nullOr lib.types.str;
      default = null;
    };
  };

  den.schema.user = {
    options.persist = lib.mkOption {
      description = "Enables the user to persist its defined home directory items.";
      type = lib.types.bool;
      default = false;
    };
  };

  den.schema.home = {
    options.persist.path = lib.mkOption {
      description = "Path to persistent storage. Enables impermanence when set.";
      type = lib.types.nullOr lib.types.str;
      default = null;
    };
  };

  den.ctx.host.includes = [impermanentHost persistHost];
  den.ctx.home.includes = [impermanentHome persistHome];
  den.ctx.user.includes = [persistUser];
}
