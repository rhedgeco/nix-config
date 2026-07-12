{
  lib,
  inputs,
  den,
  ...
}: {
  imports =
    # import flakeModule to generate top level flake structure
    [inputs.den.flakeModule]
    # then import all other den module files in this directory
    ++ (lib.custom.read.nixModulePaths ./.);

  den.default = {
    includes = [den.aspects.test];
  };
}
