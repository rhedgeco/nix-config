{
  pkgs,
  iglib,
  ...
}:
iglib.module {
  name = "ai-tools";

  home.config.home.packages = with pkgs; [
    gemini-cli
  ];
}
