lib: _: {
  custom = let
    read = import ./read.nix lib;
    libPaths = read.nixPaths ./.;
  in
    lib.listToAttrs (
      map (item: {
        name = lib.removeSuffix ".nix" (baseNameOf item);
        value = import item lib;
      })
      libPaths
    );
}
