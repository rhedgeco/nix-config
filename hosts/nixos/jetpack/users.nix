{...}: {
  igloo.users.ryan = {
    enable = true;
    config = {
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
