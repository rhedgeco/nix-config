{
  lib,
  ...
}:
{
  den.aspects.hedgebox.provides.ryan.homeManager = { pkgs, ... }: {
    den.zed.settings = lib.mkMerge [
      # load some default settings
      ./_assets/zed.json

      # set the LSP paths to the nix store locations
      {
        lsp = {
          package-version-server.binary.path = lib.getExe pkgs.package-version-server;
          crates-lsp.binary.path = lib.getExe pkgs.crates-lsp;
        };
      }
    ];
  };
}
