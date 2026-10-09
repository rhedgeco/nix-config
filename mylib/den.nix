{
  lib,
  mylib,
  inputs,
  ...
}:
{
  flake =
    root:
    let
      modulePath = root + "/modules";
      modules = inputs.import-tree modulePath;
    in
    (lib.evalModules {
      specialArgs = { inherit mylib inputs; };
      modules = [ modules ];
    }).config.flake;
}
