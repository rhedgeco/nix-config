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
    just
    gum
  ];
}
