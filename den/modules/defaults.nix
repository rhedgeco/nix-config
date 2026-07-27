{
  inputs,
  den,
  ...
}: {
  # generate top level flake config
  imports = [inputs.den.flakeModule];

  den.schema.user.includes = [
    # create OS-level user accounts for each user entity
    den.batteries.define-user
  ];
}
