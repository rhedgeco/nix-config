{pkgs, ...}: let
  # create a script that runs hyprpicker and copies it to the clipboard
  color-picker = pkgs.writeShellScriptBin "color-picker" ''
    #!${pkgs.runtimeShell}

    # run hyprpicker and store its output
    COLOR=$(${pkgs.hyprpicker}/bin/hyprpicker)

    # if the COLOR variable is not empty, then copy it to the clipboard
    if [ -n "$COLOR" ]; then
      ${pkgs.wl-clipboard-rs}/bin/wl-copy --trim-newline $COLOR
    fi
  '';
in {
  # include the script in packages so it can be run manually too
  home.packages = [color-picker];

  # create a wrapper desktop entry that runs hyprpicker
  xdg.desktopEntries."color-picker" = {
    name = "Color Picker";
    comment = "Runs a color picker and copies the hex to the clipboard";
    icon = ./icon.png;
    categories = ["Utility" "Core"];
    terminal = false;

    # use the color picker script as the exec target for the desktop entry
    exec = "${color-picker}/bin/color-picker";
  };
}
