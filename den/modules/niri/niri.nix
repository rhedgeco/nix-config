{...}: {
  den.aspects.niri = {
    nixos = {pkgs, ...}: {
      environment.systemPackages = [pkgs.niri];
    };
  };
}
