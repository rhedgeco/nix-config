{
  pkgs,
  iglib,
  ...
}:
iglib.module {
  name = "core-tools";

  # core cli tools included with any system by default
  packages = with pkgs; [
    just
    gum
  ];
}
