{...}: {
  igloo.users.ryan = {
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
}
