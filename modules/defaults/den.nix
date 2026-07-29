{
  inputs,
  den,
  ...
}: {
  # generate top level flake config
  imports = [inputs.den.flakeModule];

  den.schema.user = {
    # create OS-level user accounts for each user entity
    includes = [den.batteries.define-user];
    # enable homeManager by default for all users
    classes = ["homeManager"];
  };
}
