{ lib, ... }: {
  den.aspects.hedgebox.provides.ryan.homeManager = { pkgs, config, ... }: {
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

    home.packages = with pkgs; [
      # niri does not have a built in x server
      # xwayland-satellite fills this gap
      # it hosts an xserver and simulates wayland clients
      xwayland-satellite
      brightnessctl
      alacritty
      nautilus
      gnome-calculator
      activate-linux
      video-trimmer
      obs-studio
      typst
      gthumb
    ];

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

    persist.dirs = [
      # persist sound and mic settings
      ".local/state/wireplumber"

      # persist common user folders
      "Downloads"
      "Music"
      "Pictures"
      "Documents"
      "Videos"
    ];

    # write the noctalia settings configuration
    den.create.".config/noctalia/settings.toml" = ./_assets/noctalia/settings.toml;
    den.create.".config/noctalia/palettes/Cream.json" = ./_assets/noctalia/Cream.json;
    den.create.".local/share/noctalia/plugins" = ./_assets/noctalia/plugins;

    # have niri spawn a video wallpaper at startup
    den.niri.include."mpvpaper.kdl" =
      let
        wallpaperPath = ./_assets/wallpapers/LazyRiver.mp4;
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
      in
      ''
        spawn-at-startup "${wallpaperScript}"
      '';
  };
}
