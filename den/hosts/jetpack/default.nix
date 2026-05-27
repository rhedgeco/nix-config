{
  den,
  inputs,
  ...
}: {
  den.hosts.x86_64-linux.jetpack = {
    persist.store = "/persist";
    users.ryan.persist = true;
  };

  den.aspects.jetpack = {
    # escape hatch to use classic nixos modules
    nixos = inputs.import-tree ./_nixos;

    # set up custom ryan user for this host
    provides.ryan.includes = [
      den.batteries.primary-user
    ];
  };
}
