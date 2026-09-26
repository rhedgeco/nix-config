{
  den.aspects.hedgebox.nixos = { pkgs, ... }: {
    programs.nix-ld.enable = true;
    programs.nix-ld.libraries = with pkgs; [
      # core C/C++ runtime — almost always required
      stdenv.cc.cc.lib
      zlib

      # Python-build-standalone commonly links against these
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

      # occasionally needed by C-extension-heavy Python packages that
      # get built/imported during Bazel's Python setup or your own deps
      glib
      libxml2
      libxslt
      gdbm
      util-linux # provides libuuid

      # other
      llvmPackages.libclang
      alsa-lib
      libpcap
    ];
  };
}
