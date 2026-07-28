{lib, ...}: {
  den.aspects.jetpack.provides.ryan.homeManager = {pkgs, ...}: {
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
      brightnessctl
      alacritty
      nautilus
      gnome-calculator
      activate-linux
      video-trimmer
      typst
    ];

    persist.dirs = [
      # TODO: Remove this
      # Persist the dconf directory for now
      # but later this should be replaced with a declarative solution
      ".config/dconf"

      # persist user keyring stores between boots
      ".local/share/keyring"

      # persist common user folders
      "Downloads"
      "Music"
      "Pictures"
      "Documents"
      "Videos"
    ];

    # create core desktop assets
    create = let
      # filter niri files with extension `.kdl`
      niriKdlFiles =
        lib.filterAttrs (name: type: type == "regular" && lib.hasSuffix ".kdl" name)
        (builtins.readDir ./_assets/niri);

      # map niri files to their create routes
      niriCreate =
        lib.mapAttrs' (name: _: {
          name = ".config/niri/${name}";
          value = ./_assets/niri/${name};
        })
        niriKdlFiles;

      # create the base niri config that links everything together
      niriConfig.".config/niri/config.kdl" = pkgs.writeText "config.kdl" ''
        ${
          lib.concatMapAttrsStringSep "\n"
          (name: _: ''include "./${name}"'')
          niriKdlFiles
        }
      '';
    in
      niriCreate // niriConfig;
  };
}
