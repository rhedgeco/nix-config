let
  # tools that should be available on every system
  mkTools =
    pkgs: with pkgs; [
      bat
      vim
      nano
      direnv
      fd
      iw
      jq
      gum
      tree
      inotify-tools
      just
      python3
      pciutils
      ffmpeg
      nixfmt
    ];
in
{
  den.default = {
    nixos = { pkgs, ... }: {
      environment.systemPackages = mkTools pkgs;
    };
    homeManager = { pkgs, ... }: {
      home.packages = mkTools pkgs;
    };
  };
}
