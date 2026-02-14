{...}: {
  programs.zed-editor = {
    enable = true;
    extensions = ["nix" "toml" "rust"];
    themes = {
      "VSCode Dark Modern" = ./${"VSCode Dark Modern.json"};
    };
    userSettings = {
      ui_font_size = 16;
      buffer_font_size = 14;
      theme = {
        mode = "system";
        dark = "VSCode Dark Modern";
        light = "One Light";
      };
      minimap.show = "always";
      indent_guides.coloring = "indent_aware";
    };
  };
}
