{...}: {
  programs.git = {
    enable = true;
    lfs.enable = true;
    userName = "Ryan Hedgecock";
    userEmail = "rhedgeco@gmail.com";
    signing = {
      signByDefault = true;
      key = null;
    };
  };
}
