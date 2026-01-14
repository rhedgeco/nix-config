{...}: {
  igloo.modules.vicinae = {
    enable = true;
  };

  igloo.modules.niri = {
    enable = true;
    spawn = [
      "discord"
    ];
    spawnSh = [
      # launch the vicinae server at startup
      "vicinae server"
    ];
    float = [
      "discord"
      "org.gnome.Calculator"
    ];
    binds = {
      "Mod+W" = "firefox";
      "Mod+D" = "discord";
      "Mod+E" = "codium";

      # use vicinae as the launcher for scrollde
      "Mod+Space" = ["vicinae" "toggle"];
    };
  };
}
