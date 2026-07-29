{
  lib,
  den,
  ...
}: {
  den.aspects.jetpack.provides.ryan = {
    # zed relies on the ai-tooling
    includes = [den.aspects.ai-tools];

    homeManager = {pkgs, ...}: {
      # persist zed local share for now
      # TODO: add declarative local share content
      persist.dirs = [
        ".local/share/zed"
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
          "Dark Modern" = ./_assets/zed/DarkModern.json;
        };
        userSettings = {
          ui_font_size = 16;
          buffer_font_size = 14;
          minimap.show = "always";
          format_on_save = "on";
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
              model = "claude-sonnet-4.8";
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
  };
}
