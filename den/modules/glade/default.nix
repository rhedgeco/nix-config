{
  den.aspects.glade = {
    nixos = {pkgs, ...}: let
      # build the default niri configuration for glade
      niri-static = ./_assets/niri-static.kdl;
      niri-config = pkgs.writeText "niri-config.kdl" ''
        // static glade configuration
        include "${niri-static}"

        // include some custom nix defined binds
        binds {
          // spawn alacritty as the terminal emulator
          Mod+T { spawn "${pkgs.alacritty}/bin/alacritty"; }
        }

        // optional user overrides in home directory
        // included last so that anything can be overriden
        include optional=true "~/.config/glade/niri.kdl"
      '';

      # write a session script to configure and launch the DE
      # doing it this way ensures all config is glade specific
      # and wont get mixed up with config from another DE
      glade-session = pkgs.writeShellScript "glade-session" ''
        export PATH="$HOME/.config/glade/packages/bin:$PATH"
        export NIRI_CONFIG=${niri-config}
        exec niri-session
      '';
    in {
      # add custom glade wayland desktop entry
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
        # include some packages with glade by default
        glade.packages = with pkgs; [
          niri
        ];

        # write all default and user specified packages to the glade directory
        # these can then be added to the PATH environment before the session launches
        home.file.".config/glade/packages".source = pkgs.buildEnv {
          name = "glade-packages";
          paths = config.glade.packages;
        };
      };
    };
  };
}
