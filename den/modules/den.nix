{
  inputs,
  den,
  ...
}: {
  # generate top level flake config
  imports = [inputs.den.flakeModule];

  den.default = {
    includes = [
      den.batteries.define-user # Creates OS-level user accounts for each user entity
    ];
  };
}
