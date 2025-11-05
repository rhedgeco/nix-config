{iglib, ...}:
iglib.module {
  name = "jetpack-config";

  # import all modules in this directory
  imports = iglib.findModules ./.;

  nixos.igloo.users.ryan = {
    enable = true;
    systemConfig = {
      initialPassword = "ryan";
      extraGroups = ["wheel"];
    };
    homeConfig = {
      custom.impermanence = {
        enable = true;
        userDir = "/persist/home/ryan";
      };
    };
  };

  igloo.modules.embedded = {
    enable = true;
    users = ["ryan"];
  };
}
