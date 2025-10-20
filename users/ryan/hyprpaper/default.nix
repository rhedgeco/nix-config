{...}: let
  wallpaper = ./wallpaper.png;
in {
  services.hyprpaper = {
    enable = true;
    settings = {
      preload = ["${wallpaper}"];
      wallpaper = [",${wallpaper}"];
    };
  };
}
