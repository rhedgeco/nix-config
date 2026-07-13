{lib, ...}: {
  den.hosts.x86_64-linux.jetpack = {
    users.ryan = {};
  };

  den.aspects.jetpack = {
    # import all the nixos modules into the system
    nixos.imports = lib.custom.read.nixPaths ./nixos;
  };
}
