{
  den.aspects.glade = {
    nixos = {pkgs, ...}: let
      niri-config = ./_assets/niri-config.kdl;
      glade-session = pkgs.writeShellScript "glade-session" ''
        export PATH="$HOME/.config/glade/packages/bin:$PATH"
        export NIRI_CONFIG=${niri-config}
        exec niri-session
      '';
    in {
      services.displayManager.sessionPackages = [
        (pkgs.writeTextDir "share/wayland-sessions/glade.desktop" ''
          [Desktop Entry]
          Name=Glade
          Comment=A desktop environment based on niri
          Exec=${glade-session}
          Type=Application
          DesktopNames=glade
        '')
      ];
    };

    provides.to-users.homeManager = {
      pkgs,
      lib,
      config,
      ...
    }: {
      options.glade.packages = lib.mkOption {
        default = [];
        description = "Packages available in the glade desktop environment";
        type = lib.types.listOf lib.types.package;
      };

      config = {
        glade.packages = with pkgs; [
          niri
        ];

        home.file.".config/glade/packages".source = pkgs.buildEnv {
          name = "glade-packages";
          paths = config.glade.packages;
        };
      };
    };
  };
}
