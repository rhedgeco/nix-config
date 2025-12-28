{
  pkgs,
  iglib,
  inputs,
  ...
}: let
  system = pkgs.stdenv.hostPlatform.system;
  yoink = inputs.yoink.packages.${system}.default;
in
  iglib.module {
    name = "core-tools";
    enabled = true; # enable these tools by default

    # core cli tools included with any system by default
    packages = with pkgs; [
      bat
      direnv
      fd
      gum
      inotify-tools
      just
      python3
      yoink
    ];
  }
