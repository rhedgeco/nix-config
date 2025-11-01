{pkgs, ...}:
pkgs.stdenv.mkDerivation rec {
  pname = "video-trimmer";
  version = "25.03";

  src = pkgs.fetchFromGitLab {
    owner = "YaLTeR";
    repo = pname;
    rev = "v${version}";
    domain = "gitlab.gnome.org";
    hash = "sha256-pJCXL0voOoc8KpYECYRWGefYMrsApNPST4wv8SQlH34=";
  };

  cargoDeps = pkgs.rustPlatform.fetchCargoVendor {
    src = src;
    hash = "sha256-3ycc4jXneGsz9Jp9Arzf224JPAKM+PxUkitWcIXre8Y=";
  };

  # Dependencies needed to RUN the application
  buildInputs = with pkgs; [
    gtk4
    libadwaita
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-rs
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-libav
    gst_all_1.gst-vaapi
    gst_all_1.gst-editing-services
    ffmpeg
    glib
  ];

  # Tools needed to BUILD the application
  nativeBuildInputs = with pkgs; [
    meson
    ninja
    rustc
    cargo
    cmake
    pkg-config
    gtk4
    libadwaita
    desktop-file-utils
    appstream
    appstream-glib
    blueprint-compiler
    rustPlatform.cargoSetupHook
    wrapGAppsHook3
    makeWrapper
  ];

  postFixup = ''
    # Find our executable
    # And wrap it, forcing ffmpeg's bin path into the PATH
    wrapProgram $out/bin/video-trimmer \
      --prefix PATH : ${pkgs.lib.makeBinPath [pkgs.ffmpeg]}
  '';

  mesonBuildType = "release";
}
