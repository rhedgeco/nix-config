{...}: {
  igloo.users.ryan = {
    enable = true;
    config = {
      initialPassword = "ryan";
      extraGroups = ["wheel"];
    };
    home.custom.impermanence = {
      enable = true;
      userDir = "/persist/home/ryan";
    };
  };

  igloo.modules = {
    ai-tools.enable = true;
    printing-3d.enable = true;
    embedded.enable = true;
    docker.enable = true;
  };
}
