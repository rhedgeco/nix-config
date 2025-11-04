{
  pkgs,
  iglib,
  ...
}:
iglib.module {
  name = "cli-tools";
  packages = with pkgs; [
    just
    gum
  ];
}
