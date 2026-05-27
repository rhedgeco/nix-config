{den, ...}: {
  den.hosts.x86_64-linux.jetpack = {
    persist.store = "/persist";
    users.ryan.persist = true;
  };

  den.aspects.jetpack = {
    includes = [
      den.aspects.niri
    ];

    provides.ryan.includes = [
      den.batteries.primary-user
    ];
  };
}
