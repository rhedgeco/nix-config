{pkgs, ...}: {
  igloo.modules = {
    fishy.enable = true;
    steam.enable = true;
    discord.enable = true;
    color-picker.enable = true;
    embedded.enable = true;
    docker.enable = true;
    ai-tools.enable = true;
    printing-3d.enable = true;
    rust.enable = true;
    zed.enable = true;
    spotify.enable = true;
    flatpak.enable = true;
    noctalia.enable = true;
    greetd.command = "${pkgs.niri}/bin/niri-session";
  };
}
