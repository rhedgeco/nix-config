{
  den.aspects.bambu.homeManager =
    { pkgs, ... }:
    let
      pname = "bambu-studio";
      version = "02.08.01.55";

      src = pkgs.fetchurl {
        url = "https://github.com/bambulab/BambuStudio/releases/download/v${version}/BambuStudio_ubuntu24.04-v${version}-20260715113557.AppImage";
        hash = "sha256-IlECQz2/zEdcvXm++gRTu5P5880Vu0OEgECn/iIRx94=";
      };

      appimageContents = pkgs.appimageTools.extract {
        inherit pname version src;
      };

      bambu-studio-official = pkgs.appimageTools.wrapType2 {
        inherit pname version src;

        extraInstallCommands = ''
          install -m 444 -D ${appimageContents}/BambuStudio.desktop $out/share/applications/BambuStudio.desktop
          install -m 444 -D ${appimageContents}/BambuStudio.png $out/share/icons/hicolor/128x128/apps/BambuStudio.png

          # Point Exec to our wrapped Nix store binary
          substituteInPlace $out/share/applications/BambuStudio.desktop \
            --replace-fail 'Exec=AppRun' 'Exec=bambu-studio'
        '';

        extraPkgs =
          pkgs: with pkgs; [
            # bambu cloud TLS/SSL connection
            cacert
            glib-networking
            webkitgtk_4_1
            openssl
            curl
            zlib

            # LAN/mDNS Discovery
            avahi
            dbus
            systemd

            # audio/video streaming for live camera feeds
            gst_all_1.gstreamer
            gst_all_1.gst-plugins-base
            gst_all_1.gst-plugins-good
            gst_all_1.gst-plugins-bad
            gst_all_1.gst-plugins-ugly
          ];

        # environment variables for bambu cloud ssl handshakes
        # and force gtk and webkit components into dark mode
        profile = ''
          export SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt
          export GIO_EXTRA_MODULES=${pkgs.glib-networking}/lib/gio/modules
          export GTK_THEME="Adwaita:dark"
          export ADW_DISABLE_PORTAL=1
        '';
      };
    in
    {
      home.packages = [ bambu-studio-official ];
      persist.dirs = [
        ".config/BambuStudio"
        ".config/BambuStudioBeta"
        ".local/share/bambu-studio"
      ];
    };
}
