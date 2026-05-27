{
  den.aspects.glade = {
    nixos = {pkgs, ...}: let
      niri-config = ./_assets/niri-config.kdl;
      glade-session = pkgs.writeShellScript "glade-session" ''
        SESSION_DIR="$HOME/.sessions/glade"

        # Add session packages to PATH
        if [ -d "$SESSION_DIR/packages/bin" ]; then
          export PATH="$SESSION_DIR/packages/bin:$PATH"
        fi

        # Load session environment
        if [ -f "$SESSION_DIR/env.sh" ]; then
          source "$SESSION_DIR/env.sh"
        fi

        # Run pre-compositor init
        if [ -f "$SESSION_DIR/init.sh" ]; then
          source "$SESSION_DIR/init.sh"
        fi

        # Set niri config (after env.sh so it can't be overridden)
        export NIRI_CONFIG=${niri-config}

        # Start niri (run.sh is for post-compositor commands,
        # which niri handles via spawn-at-startup in its config)
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

    provides.to-users.homeManager = {pkgs, ...}: {
      sessions.glade.packages = with pkgs; [
        niri
      ];
    };
  };
}
