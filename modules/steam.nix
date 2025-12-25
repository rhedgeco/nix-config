{iglib, ...}:
iglib.module {
  name = "steam";

  nixos.enabled = {
    programs.steam = {
      enable = true;
    };
  };

  home.enabled = {
    igloo.modules.persist.dirs = [
      ".local/share/Steam"
      ".steam"
    ];
  };
}
