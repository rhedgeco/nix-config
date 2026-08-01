{
  lib,
  den,
  ...
}: {
  den.aspects.jetpack.provides.ryan = {
    # zed relies on the ai-tooling
    includes = [den.aspects.ai-tools];

    homeManager = {pkgs, ...}: {
      home.packages = with pkgs; [
        # include the main editor
        zed-editor

        # include supporting packages for editing nix
        nixd
        nil
      ];

      # persist zed local share for now
      # TODO: add declarative local share content
      persist.dirs = [
        ".local/share/zed"
      ];

      # apply the zed theme
      create.".config/zed/themes/DarkModern.json" = ./_assets/zed/DarkModern.json;

      # apply the zed settings
      create.".config/zed/settings.json" = builtins.toJSON (
        lib.recursiveUpdate
        # load the existing json file
        (builtins.fromJSON (builtins.readFile ./_assets/zed/settings.json))
        # then merge some custom nix values into it
        {
          lsp = {
            package-version-server.binary.path = lib.getExe pkgs.package-version-server;
            crates-lsp.binary.path = lib.getExe pkgs.crates-lsp;
          };
        }
      );
    };
  };
}
