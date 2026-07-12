{
  den.aspects.test = {
    nixos = {pkgs, ...}: {
      environment.systemPackages = [pkgs.hello];
    };
  };
}
