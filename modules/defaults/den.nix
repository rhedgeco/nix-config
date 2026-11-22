{
  inputs,
  den,
  ...
}:
{
  # generate top level flake config
  imports = [ inputs.den.flakeModule ];

  den.schema.user = {
    # create OS-level user accounts for each user entity
    includes = [ den.batteries.define-user ];
    # enable homeManager by default for all users
    classes = [ "homeManager" ];
  };

  # adopt dens new user to host mapping
  # anthing that gets routed between user and host
  # must use provides.to-hosts / provides.to-hosts explicitly
  den.migrations.user-host-content.acknowledged = true;
  den.schema.host.includes = [ den.batteries.mutual-provider ];
}
