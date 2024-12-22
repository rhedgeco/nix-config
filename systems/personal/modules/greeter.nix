{
  pkgs,
  inputs,
  ...
}: {
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
