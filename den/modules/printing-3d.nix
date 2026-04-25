{...}: {
  den.aspects.printing-3d = {
    nixos = {pkgs, ...}: {
      environment.systemPackages = with pkgs; [
        prusa-slicer
        printrun
      ];
    };
  };
}
