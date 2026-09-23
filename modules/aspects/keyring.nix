{ ... }: {
  den.aspects.keyring.homeManager = { pkgs, ... }: {
    services.gnome-keyring.enable = true;
    dbus.packages = with pkgs; [
      gnome-keyring
      seahorse
      gcr_3
    ];

    home.packages = with pkgs; [
      gnome-keyring
      seahorse

      # create a shell script to lock the keyring
      (pkgs.writeShellScriptBin "lock-keyring" ''
        ${dbus}/bin/dbus-send --session --dest=org.freedesktop.secrets --type=method_call /org/freedesktop/secrets org.freedesktop.Secret.Service.Lock array:objpath:/org/freedesktop/secrets/collection/login
      '')
    ];

    # persist the keyring directory
    persist.dirs = [
      {
        directory = ".local/share/keyrings";
        mode = "0700";
      }
    ];
  };
}
