{
  pkgs,
  iglib,
  ...
}:
iglib.module {
  name = "ai-tools";

  packages = with pkgs; [
    gemini-cli
  ];
}
