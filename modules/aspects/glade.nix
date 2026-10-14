{
  lib,
  den,
  inputs,
  ...
}:
{
  den.aspects.glade = {
    includes = [
      den.aspects.niri # window manager
      den.aspects.noctalia # desktop shell
      den.aspects.vicinae # app launcher
      den.aspects.keyring # gnome keyring
      den.aspects.firefox # web browser
    ];

    homeManager = { pkgs, config, ... }: {
      # set up packages included by default with glade
      home.packages = with pkgs; [
        brightnessctl
        alacritty
        nautilus
        gnome-calculator
        activate-linux
        video-trimmer
        obs-studio
        typst
        gthumb
        showtime
      ];

      # add a desktop entry for the noctalia color picker
      xdg.desktopEntries."color-picker" = {
        name = "Color Picker";
        comment = "Color Picker noctalia panel";
        icon = ./_assets/color-picker.png;
        categories = [
          "Utility"
          "Core"
        ];
        terminal = false;
        exec = "noctalia msg panel-toggle oldirtty/color_picker:panel";
      };

      # use the bibata modern cursor
      home.pointerCursor = {
        enable = true;
        gtk.enable = true;
        x11.enable = true;
        name = "Bibata-Modern-Classic";
        package = pkgs.bibata-cursors;
        size = 22;
      };

      # set up vicinae
      den.vicinae = {
        opacity = 0.7;
        favorites = [
          "applications:firefox"
          "applications:org.gnome.Nautilus"
        ];
      };

      # enable the xdg desktop portal
      xdg.portal = {
        enable = true;

        # Extra portals required for Niri screen recording / screenshots
        extraPortals = with pkgs; [
          xdg-desktop-portal-gnome # Recommended backend for Niri screencasting
          xdg-desktop-portal-gtk # Standard fallback for file pickers/dialogs
        ];

        # Map portal implementations specifically for Niri
        config = {
          niri = {
            default = [
              "gnome"
              "gtk"
            ];
            "org.freedesktop.impl.portal.Screencast" = [ "gnome" ];
            "org.freedesktop.impl.portal.Screenshot" = [ "gnome" ];
          };
          common = {
            default = [ "gtk" ];
          };
        };
      };

      gtk = {
        enable = true;
        iconTheme = {
          name = "Papirus-Dark";
          package = pkgs.papirus-icon-theme.override {
            color = "green";
          };
        };
        theme = {
          name = "Orchis-Orange-Dark-Compact";
          package = pkgs.orchis-theme.override {
            border-radius = 15;
            tweaks = [ "macos" ];
          };
        };
        gtk4.theme = config.gtk.theme;
        gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
        gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;
      };
      dconf.settings = {
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
          gtk-theme = "Orchis-Orange-Dark-Compact";
          icon-theme = "Papirus-Dark";
        };
      };

      # set up glade noctalia assets
      den.noctalia.includes = [ ./_assets/glade/noctalia/settings.toml ];
      den.noctalia.palettes."Cream" = ./_assets/glade/noctalia/Cream.json;

      # manually apply some noctalia settings
      den.noctalia.settings = {
        # default mpv wallpaper settings
        plugin_settings."noctalia/mpvpaper" = {
          mpv_options = "panscan=1.0 profile=fast";
          video_directory = "${inputs.abitoads.packages.${pkgs.stdenv.hostPlatform.system}.all}";
        };
      };

      # include the notes and color picker plugin from noctalia repos
      den.noctalia.plugins.community = [ "color_picker" ];
      den.noctalia.plugins.official = [
        "mpvpaper"
        "notes"
      ];

      # include extra packages available to noctalia
      den.noctalia.extraPackages = with pkgs; [
        # required by color_picker plugin
        hyprpicker

        # required by mpvpaper plugin
        mpvpaper
        mpv
      ];

      # write some default niri config specifically for glade
      den.niri.includes = [
        (pkgs.writeText "glade-default.kdl" ''
          // glade's default niri configuration files
          ${lib.concatMapStringsSep "\n" (path: ''include "${./_assets/glade/niri/${path}}"'') (
            builtins.attrNames (builtins.readDir ./_assets/glade/niri)
          )}
        '')
      ];

      persist.dirs = [
        # persist common user folders
        "Downloads"
        "Music"
        "Pictures"
        "Documents"
        "Videos"

        # persist some plugin folders for glade
        ".cache/noctalia/mpvpaper"
        ".local/state/noctalia/mpvpaper"
      ];
    };
  };
}
