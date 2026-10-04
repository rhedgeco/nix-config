{ lib, den, ... }: {
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

      # include all the niri assets
      den.niri.includes =
        let
          wallpaperPath = ./_assets/glade/wallpaper/LazyRiver.mp4;
          mpvOptions = [
            "aid=no" # no audio
            "--loop-file=inf" # loop the video forever
            "--hwdec=auto-safe" # pick best available hw decoder, fall back to software
            "--video-sync=display-resample" # sync playback to display refresh
            "--panscan=1.0" # crop to fill the screen
            "--profile=fast" # lighter rendering, quality irrelevant for a wallpaper
            "--cache=no" # no streaming cache needed for a local file
            "--demuxer-max-bytes=64MiB" # cap forward demuxer buffer (prevents leak)
            "--demuxer-max-back-bytes=32MiB" # cap back-buffer (prevents leak)
          ];

          wallpaperScript = pkgs.writeShellScript "launch-wallpaper" ''
            # run under jemalloc to avoid glibc arena fragmentation over long sessions
            export LD_PRELOAD="${pkgs.jemalloc}/lib/libjemalloc.so"
            ${pkgs.mpvpaper}/bin/mpvpaper \
            -o "${lib.concatStringsSep " " mpvOptions}" \
            "*" ${wallpaperPath}
          '';

          mpvKdl = {
            "glade/wallpaper.kdl" = ''spawn-at-startup "${wallpaperScript}"'';
          };

          otherKdl = lib.mapAttrs' (name: _: {
            name = "glade/${name}";
            value = ./_assets/glade/niri/${name};
          }) (builtins.readDir ./_assets/glade/niri);
        in
        mpvKdl // otherKdl;

      # set up glade noctalia assets
      den.noctalia.settings = ./_assets/glade/noctalia/settings.toml;
      den.noctalia.palettes."Cream" = ./_assets/glade/noctalia/Cream.json;
      den.noctalia.plugins."notes" = ./_assets/glade/noctalia/plugins/notes;

      persist.dirs = [
        # persist common user folders
        "Downloads"
        "Music"
        "Pictures"
        "Documents"
        "Videos"
      ];
    };
  };
}
