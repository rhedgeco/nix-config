{...}: {
  igloo = {
    users.ryan = {
      enable = true;
      config = {
        initialPassword = "ryan";
        extraGroups = ["wheel"];
      };
    };

    modules = {
      grub.enable = true;
      steam.enable = true;
      flatpak.enable = true;
      kde-connect.enable = true;
      boot.device = "/dev/disk/by-label/BOOT";

      greetd = {
        enable = true;
        autoLogin = "ryan";
      };

      persist = {
        enable = true;
        location = "/persist";
        files = [
          "/etc/machine-id"
        ];
        dirs = [
          "/var/log" # system log files
          "/var/lib/nixos" # needed for nixos systems
          "/var/lib/systemd/coredump" # systemd coredump info
        ];
      };
    };
  };
}
