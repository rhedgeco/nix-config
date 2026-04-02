{iglib, ...}:
iglib.module {
  name = "kde-connect";

  nixos.enabled = {
    programs.kdeconnect.enable = true;
  };
}
