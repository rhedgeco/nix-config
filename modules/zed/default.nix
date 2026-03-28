{
  lib,
  pkgs,
  iglib,
  ...
}:
iglib.module {
  name = "zed";

  home.enabled = {
    igloo.modules.persist.dirs = [
      # persist zed local share for now
      # TODO: add declarative local share content
      ".local/share/zed"

      # persist copilot authorization
      ".config/github-copilot"
    ];

    # enable and configure the zed editor
    programs.zed-editor = {
      enable = true;
      extensions = [
        "nix"
        "toml"
        "rust"
        "xml"
        "html"
        "just"
        "catppuccin-icons"
        "crates-lsp"
        "git-firefly"
        "kdl"
      ];
      extraPackages = with pkgs; [
        nil
        nixd
        alejandra
      ];
      themes = {
        "Dark Modern" = ./theme.json;
      };
      userSettings = {
        ui_font_size = 16;
        buffer_font_size = 14;
        minimap.show = "always";
        title_bar.show_menus = true;
        outline_panel.dock = "left";
        project_panel.dock = "left";
        icon_theme = "Catppuccin Mocha";
        theme = {
          mode = "system";
          dark = "Dark Modern";
          light = "One Light";
        };
        indent_guides.coloring = "indent_aware";
        git_panel = {
          dock = "left";
          tree_view = true;
        };
        agent = {
          dock = "right";
          default_model = {
            provider = "copilot_chat";
            model = "claude-opus-4.6";
          };
          thread_summary_model = {
            provider = "copilot_chat";
            model = "claude-sonnet-4.6";
          };
        };
        lsp = {
          package-version-server.binary.path = lib.getExe pkgs.package-version-server;
          crates-lsp.binary.path = lib.getExe pkgs.crates-lsp;
          nil.initialization_options.formatting.command = ["alejandra"];
        };
      };
    };
  };
}
