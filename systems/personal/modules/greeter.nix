{
  pkgs,
  inputs,
  ...
}: {
  # use regreet with custom theme
  programs.regreet = {
    enable = true;
    theme = {
      name = "Orchis-Orange-Dark-Compact";
      package =
        pkgs.orchis-theme.override
        {
          border-radius = 6;
          tweaks = ["macos" "submenu"];
        };
    };
  };
}
