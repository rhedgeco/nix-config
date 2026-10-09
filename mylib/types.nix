{ lib, ... }: rec {
  # an explicit set of JSON values
  jsonValue = lib.types.nullOr (
    lib.types.oneOf [
      lib.types.bool
      lib.types.int
      lib.types.float
      lib.types.str
      (lib.types.listOf jsonValue)
      attrsRec
    ]
  );

  # a recursive attrset of JSON values
  attrsRec = lib.types.attrsOf jsonValue;

  # coerces strings into attr sets
  fromToml = fromStr (s: fromTOML s);
  fromJson = fromStr (s: builtins.fromJSON s);
  fromStr =
    func:
    lib.types.coercedTo lib.types.path (p: builtins.readFile p) (
      lib.types.coercedTo lib.types.str func attrsRec
    );

  # coerces strings into store paths
  intoPath = name: with lib.types; coercedTo str (s: builtins.toFile name s) path;
}
