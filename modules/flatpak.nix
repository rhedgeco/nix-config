{iglib, ...}:
iglib.module {
  name = "flatpak";

  home.enabled = {
    igloo.modules.persist.dirs = [
      ".var/app/com.bambulab.BambuStudio"
    ];
  };

  nixos.enabled = {
    services.flatpak.enable = true;
    igloo.modules.persist.dirs = [
      "/var/lib/flatpak"
    ];
  };
}
