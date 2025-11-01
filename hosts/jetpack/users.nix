{...}: {
  igloo.users.ryan = {
    enable = true;
    settings = {
      initialPassword = "ryan";
      extraGroups = ["wheel"];
    };
    config = {
      custom.impermanence = {
        enable = true;
        userDir = "/persist/home/ryan";
      };
    };
  };
}
