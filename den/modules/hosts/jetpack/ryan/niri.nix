{lib, ...}: {
  den.aspects.jetpack.provides.ryan.homeManager = {pkgs, ...}: {
    # TODO: Remove this
    # Persist the dconf directory for now
    # but later this should be replaced with a declarative solution
    persist.dirs = [
      ".config/dconf"
    ];

    # enable keyring related items
    services.gnome-keyring.enable = true;
    dbus.packages = with pkgs; [
      gnome-keyring
      seahorse
      gcr
    ];

    home.packages = with pkgs; [
      # niri does not have a built in x server
      # xwayland-satellite fills this gap
      # it hosts an xserver and simulates wayland clients
      xwayland-satellite
      alacritty
      nautilus
      gnome-calculator
    ];

    # map all the kdl files in the niri directory to the cofig
    create = let
      # filter only files with extension `.kdl`
      kdlFiles =
        lib.filterAttrs (name: type: type == "regular" && lib.hasSuffix ".kdl" name)
        (builtins.readDir ./_assets/niri);

      # map those files to their create routes
      createSet =
        lib.mapAttrs' (name: _: {
          name = ".config/niri/${name}";
          value = ./_assets/niri/${name};
        })
        kdlFiles;
    in
      # merge the create set with the final config file
      createSet
      // {
        ".config/niri/config.kdl" = pkgs.writeText "config.kdl" ''
          ${
            lib.concatMapAttrsStringSep "\n"
            (name: _: ''include "./${name}"'')
            kdlFiles
          }
        '';
      };
  };
}
