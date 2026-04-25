{
  den,
  inputs,
  ...
}: {
  imports = [inputs.den.flakeModule];

  den.default = {
    includes = [
      # Automatically sets the host’s name to the one defined in den.hosts.<name>.hostName. Works on NixOS/Darwin/WSL.
      den.provides.hostname
    ];
  };
}
