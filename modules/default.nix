{
  lib,
  pkgs,
  ...
}: let
  # get all the files in the current directory
  files = builtins.readDir ./.;

  # filter files to only include nix modules
  nixModules = lib.attrNames (lib.filterAttrs (
      name: type:
        type
        == "directory"
        || type
        == "regular"
        && name != "default.nix"
        && lib.strings.hasSuffix ".nix" name
    )
    files);
in {
  # import all the nix modules in this directory
  imports = lib.map (name: ./. + "/${name}") nixModules;

  # mark the host platform as x86 by default on all systems
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  # allow unfree packages by default
  nixpkgs.config.allowUnfree = lib.mkDefault true;

  # enable flakes
  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    auto-optimise-store = lib.mkDefault true;
  };

  # add default system fonts
  fonts = {
    packages = with pkgs; [
      # used for default system fonts
      nerd-fonts.noto
      nerd-fonts.jetbrains-mono
      noto-fonts-cjk-sans
      noto-fonts-emoji
    ];

    fontconfig.defaultFonts = {
      serif = ["Noto Serif Nerd Font"];
      sansSerif = ["Noto Sans Nerd Font"];
      emoji = ["Noto Color Emoji"];
      monospace = ["JetBrains Mono Nerd Font"];
    };
  };

  # set los angeles as the default time zone for all systems
  time.timeZone = lib.mkDefault "America/Los_Angeles";

  # do not change (unless you know what you are doing)
  system.stateVersion = "24.05";
}
