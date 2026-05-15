{
  den,
  lib,
  inputs,
  ...
}: let
  # helper functions for inspecting host/user schemas
  isNixos = host: host.class == "nixos";
  hasStore = host: host.persist.store != null;

  # Import impermanence NixOS module when a host has persist configured
  importImpermanence = {host, ...}: {
    nixos = lib.optionalAttrs (isNixos host && hasStore host) {
      imports = [inputs.impermanence.nixosModules.impermanence];
    };
  };

  # Forward persist-nixos class into environment.persistence.<store> on NixOS hosts
  persistNixos = {host, ...}:
    den.batteries.forward {
      each = lib.optional (isNixos host && hasStore host) host;
      fromClass = _: "persist-nixos";
      intoClass = _: host.class;
      intoPath = _: [
        "environment"
        "persistence"
        host.persist.store
      ];
      fromAspect = _: host.aspect;
    };

  # Forward persist-home class from user aspects into environment.persistence.<store>.users.<userName> on NixOS hosts
  persistNixosUser = {
    host,
    user,
    ...
  }:
    den.batteries.forward {
      each = lib.optional (isNixos host && hasStore host && user.persist) user;
      fromClass = _: "persist-home";
      intoClass = _: host.class;
      intoPath = _: [
        "environment"
        "persistence"
        host.persist.store
        "users"
        user.userName
      ];
      fromAspect = _: user.aspect;
    };
in {
  den.schema.host = {
    includes = [importImpermanence persistNixos];
    options.persist.store = lib.mkOption {
      description = "Path to persistent storage location.";
      type = lib.types.nullOr lib.types.str;
      default = null;
    };
  };

  den.schema.user = {
    includes = [persistNixosUser];
    options.persist = lib.mkOption {
      description = "Enable user to persist its home directory items.";
      type = lib.types.bool;
      default = false;
    };
  };
}
