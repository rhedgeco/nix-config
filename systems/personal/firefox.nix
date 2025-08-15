{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    firefox
  ];

  # TODO: Remove this
  # persist the '.mozilla' directory for now
  # but later this should be replaced with a declarative solution
  environment.persistence."/persist".users.ryan = {
    directories = [
      ".mozilla"
    ];
  };

  # use firefox as default mime type for PDFs
  xdg.mime = {
    defaultApplications = {
      "application/pdf" = "firefox.desktop";
    };
  };
}
