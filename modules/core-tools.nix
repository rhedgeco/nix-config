{
  pkgs,
  iglib,
  ...
}:
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
  ];
}
