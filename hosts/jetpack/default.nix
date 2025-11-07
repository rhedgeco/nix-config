{iglib, ...}:
iglib.module {
  name = "jetpack-config";
  enabled = true; # enabled by default

  # import all modules in this directory
  imports = iglib.findModules ./.;

  nixos.igloo.users.ryan = {
    enable = true;
    config = {
      initialPassword = "ryan";
      extraGroups = ["wheel"];
    };
    imports = [
      {
        custom.impermanence = {
          enable = true;
          userDir = "/persist/home/ryan";
        };
      }
    ];
  };

  igloo.modules.embedded = {
    enable = true;
    users = ["ryan"];
  };
}
