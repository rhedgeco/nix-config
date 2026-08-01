{
  den.aspects.color-picker.homeManager =
    { pkgs, ... }:
    let
      # create a script that runs hyprpicker and copies it to the clipboard
      color-picker = pkgs.writeShellScriptBin "color-picker" ''
        # check for a delay value and sleep before running the picker
        sleep "''${1:-0}"

        # run hyprpicker and store its output
        COLOR=$(${pkgs.hyprpicker}/bin/hyprpicker)

        # if the COLOR variable is not empty, then copy it to the clipboard
        if [ -n "$COLOR" ]; then
          ${pkgs.wl-clipboard-rs}/bin/wl-copy --trim-newline $COLOR
        fi
      '';
    in
    {
      # include the script in packages so it can be run from the terminal
      home.packages = [ color-picker ];

      # create a wrapper desktop entry that runs hyprpicker
      xdg.desktopEntries."color-picker" = {
        name = "Color Picker";
        comment = "pick hex values to the clipboard";
        icon = ./_assets/color-picker.png;
        categories = [
          "Utility"
          "Core"
        ];
        terminal = false;

        # use the color picker script as the exec target for the desktop entry
        # apply a slight launch delay so that any launch animations complete
        exec = "${color-picker}/bin/color-picker 0.1";
      };
    };
}
