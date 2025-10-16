{
  buildHome = {
    name,
    config ? {},
  }: {...}: {
    imports = [
      # import the user module
      (./. + "/${name}")

      # import all user modules
      ./modules

      # import all the custom user config
      ({...}: {inherit config;})
    ];

    # set user name and directory settings
    home.username = "${name}";
    home.homeDirectory = "/home/${name}";
  };
}
