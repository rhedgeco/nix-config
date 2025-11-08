{...}: {
  igloo.users.ryan = {
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
