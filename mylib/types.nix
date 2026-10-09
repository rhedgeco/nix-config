lib: rec {
  # coerces strings into attr sets
  fromToml = fromStr (s: fromTOML s);
  fromJson = fromStr (s: builtins.fromJSON s);
  fromStr =
    func:
    lib.types.coercedTo lib.types.path (p: builtins.readFile p) (
      lib.types.coercedTo lib.types.str func lib.types.attrs
    );

  # coerces strings into store paths
  intoPath = name: with lib.types; coercedTo str (s: builtins.toFile name s) path;
}
