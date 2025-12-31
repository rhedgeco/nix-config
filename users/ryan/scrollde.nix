{pkgs, ...}: {
  igloo.modules.scrollde = {
    enable = true;
    spawn = [
      "${pkgs.legcord}/bin/legcord"
    ];
  };
}
