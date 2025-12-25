{pkgs, ...}: {
  igloo.modules = {
    steam.enable = true;
    color-picker.enable = true;
    embedded.enable = true;
    docker.enable = true;
    ai-tools.enable = true;
    printing-3d.enable = true;
    vscodium.enable = true;
    rust.enable = true;
    greetd.command = "${pkgs.niri}/bin/niri-session";
  };
}
