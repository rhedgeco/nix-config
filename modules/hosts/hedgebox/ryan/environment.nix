{
  den.aspects.hedgebox.provides.ryan.homeManager =
    { pkgs, ... }:
    let
      nativeLibs = with pkgs; [
        stdenv.cc.cc.lib
        zlib
        openssl
        bzip2
        xz
        libffi
        ncurses
        readline
        sqlite
        expat
        tcl
        tk
        zstd
        glib
        libxml2
        libxslt
        gdbm
        util-linux
        libglvnd
        gtk3
        cairo
        pango
        gdk-pixbuf
        atk
        gst_all_1.gstreamer
        gst_all_1.gst-plugins-base
        gst_all_1.gst-plugins-good
        gst_all_1.gst-plugins-bad
        gst_all_1.gst-plugins-ugly
        gst_all_1.gst-libav
        alsa-lib
        libpcap
        linuxHeaders
        glibc.dev
        nodejs
      ];
    in
    {
      persist.files = [
        ".netrc"
      ];

      persist.dirs = [
        ".cargo"
      ];

      den.create.".bazelrc" = ''
        build --action_env=PATH=/run/current-system/sw/bin:/run/wrappers/bin:/home/ryan/.nix-profile/bin:/usr/bin:/bin
        build --host_action_env=PATH=/run/current-system/sw/bin:/run/wrappers/bin:/home/ryan/.nix-profile/bin:/usr/bin:/bin
      '';

      den.create.".cargo/config.toml" = "
        [net]
        git-fetch-with-cli = true
      ";

      home.sessionVariables = {
        LIBCLANG_PATH = "${pkgs.llvmPackages.libclang.lib}/lib";
        LIBRARY_PATH = pkgs.lib.makeLibraryPath nativeLibs;
        LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath nativeLibs;
        BINDGEN_EXTRA_CLANG_ARGS = "-I${pkgs.linuxHeaders}/include -I${pkgs.glibc.dev}/include -isystem ${pkgs.llvmPackages.clang}/resource-root/include";
        PKG_CONFIG_PATH = pkgs.lib.makeSearchPathOutput "dev" "lib/pkgconfig" nativeLibs;
      };

      home.packages =
        with pkgs;
        [
          rpm
          bmaptool
          file
          linuxHeaders
          glibc.dev
          gst_all_1.gstreamer
          gst_all_1.gst-plugins-base
          gst_all_1.gst-plugins-good
          gst_all_1.gst-plugins-bad
          gst_all_1.gst-plugins-ugly
          bazelisk
          git-repo
          libGLU
          unzip
          xz
          zip
          ninja
          pkg-config
          gtk3
          libpcap
          libv4l
          opencv
          libclang
          v4l-utils
          alsa-lib
          gtest
          valgrind
          jq
          flutter
          bazel
          llvmPackages.libclang
          openssl
        ]
        ++ nativeLibs;
    };
}
