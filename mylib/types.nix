{ lib, ... }: rec {
  # json style recursive value type
  recursiveType =
    with lib.types;
    nullOr (oneOf [
      bool
      int
      float
      str
      recursiveList
      recursiveAttrs
    ]);

  # json style recursive collection types
  recursiveList = lib.types.listOf recursiveType;
  recursiveAttrs = lib.types.attrsOf recursiveType;

  # helper for coercing strings and paths into attr sets
  recursiveFromStr = func: with lib.types; coercedTo str func recursiveAttrs;
  recursiveFromFile = func: with lib.types; coercedTo path builtins.readFile (recursiveFromStr func);

  # accepts strings or paths and maps them into recursive structues
  recursiveFromToml = recursiveFromFile fromTOML;
  recursiveFromJson = recursiveFromFile builtins.fromJSON;

  # coerces strings into paths
  strIntoPath = name: with lib.types; coercedTo str (builtins.toFile name) path;
  strIntoStore = name: with lib.types; either pathInStore (strIntoPath name);
}
