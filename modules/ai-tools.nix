{
  pkgs,
  iglib,
  ...
}:
iglib.module {
  name = "ai-tools";

  home.enabled.home.packages = with pkgs; [
    gemini-cli
  ];
}
