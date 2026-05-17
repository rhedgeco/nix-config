{
  den,
  lib,
  ...
}: {
  den.aspects.zed = {
    includes = [
      # include copilot for ai integration
      den.aspects.copilot
    ];

    homeManager = {pkgs, ...}: {
      persist.directories = [
        # persist zed local share for now
        # TODO: add declarative local share content
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
          "Dark Modern" = ./_assets/theme.json;
        };
        userSettings = {
          ui_font_size = 16;
          buffer_font_size = 14;
          theme = {
            mode = "system";
            dark = "Dark Modern";
            light = "One Light";
          };
          icon_theme = "Catppuccin Mocha";
          agent = {
            default_model = {
              provider = "copilot_chat";
              model = "claude-opus-4.6";
            };
            thread_summary_model = {
              provider = "copilot_chat";
              model = "claude-sonnet-4.6";
            };
          };
          title_bar.show_menus = true;
          minimap.show = "always";
          indent_guides.coloring = "indent_aware";
          git_panel.tree_view = true;
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
