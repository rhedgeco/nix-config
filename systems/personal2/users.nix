{inputs, ...}: {
  # set up system users
  users.users = {
    ryan = {
      isNormalUser = true;
      useDefaultShell = true;
      initialPassword = "ryan";
      extraGroups = [
        "wheel"
        "dialout"
        "docker"
        "networkmanager"
      ];
    };
  };

  # set up persistent directories for users
  systemd.tmpfiles.settings = {
    "persistent_user_directories" = {
      "/persist/users/ryan" = {
        d.user = "ryan";
        d.group = "users";
        d.mode = "0700";
      };
    };
  };

  # set up home manager for users
  home-manager = {
    useGlobalPkgs = true;
    extraSpecialArgs = {inherit inputs;};
    users.ryan = import ./home/ryan;
  };
}
