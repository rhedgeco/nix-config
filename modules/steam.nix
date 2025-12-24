{iglib, ...}:
iglib.module {
  name = "steam";

  nixos.enabled = {
    programs.steam = {
      enable = true;
    };
  };
}
