{
  lib,
  pkgs,
  ...
}: let
  wallpaperAlign = -0.0;
  wallpaperSrc = ./wallpapers/LazyRiver.mp4;
  mpvFlags = [
    # Hardware Acceleration
    "--hwdec=auto-safe" # automatically use the best hardware driver
    "--vd-lavc-dr=yes" # enable direct rendering
    "--gpu-context=wayland" # use wayland gpu context

    # Streaming, Synchronization
    "--loop-file=yes" # set to infinite loop from local file
    "--no-audio" # dont use audio engine, or initialize sound cards

    # Positioning, Framing, Scaling
    "--panscan=1.0" # center and fill the video stream
    "--video-align-y=${toString wallpaperAlign}" # shift vertical alignment
    "--dscale=bilinear" # use bilinear scaling when downscaling
    "--cscale=bilinear" # use the same scaling for chroma scaling
    "--sws-scaler=fast-bilinear" # fallback to fast software scaler
    "--correct-downscaling=no" # tell the downscaler that it doesnt have to be "correct" and bilinear is fine

    # Memory Management
    "--cache=no" # disable stream cache (not needed for local files)
    "--demuxer-max-bytes=50MiB" # cap demuxer buffer to prevent unbounded growth
    "--demuxer-max-back-bytes=10MiB" # limit backward seek buffer
  ];
  wallpaperRunner = pkgs.writeShellScript "anim-wallpaper" ''
    # Run mpvpaper using an infinite anonymous streaming pipe
    # use ffmpeg as the stream pipe to play an infinitely looping mp4 video
    exec ${pkgs.mpvpaper}/bin/mpvpaper -o "${lib.concatStringsSep " " mpvFlags}" ALL "${wallpaperSrc}"
  '';
in {
  igloo.modules.niri = {
    enable = true;
    spawn = [
      "discord"

      # run the animated wallpaper
      "${wallpaperRunner}"

      # meme activate linux overlay
      "${pkgs.activate-linux}/bin/activate-linux"
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
      "Mod+E" = "zeditor";

      # use vicinae as the launcher for scrollde
      "Mod+Space" = ["vicinae" "toggle"];
    };
  };
}
