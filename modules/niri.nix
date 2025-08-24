{
  lib,
  config,
  ...
}: {
  options.custom.niri = {
    enable = lib.mkEnableOption "Enable niri";
  };

  config = lib.mkIf config.custom.niri {
    # enable the niri window manager
    programs.niri.enable = true;

    environment.systemPackages = with pkgs; [
      # niri does not have a built in x server
      # xwayland-satellite fills this gap
      # it hosts an xserver and simulates wayland clients
      xwayland-satellite

      # niri expects alacritty as its default terminal
      alacritty

      # niri expects fuzzel as its default app launcher
      fuzzel

      # niri starts up waybar when it is launched by default
      waybar

      # include hyprlock for use as a screen locker
      hyprlock

      # include hyprpaper for wallpaper management
      hyprpaper

      # include light to control backlight
      light
    ];
  };
}
