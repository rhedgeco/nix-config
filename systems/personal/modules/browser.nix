{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    vivaldi
    firefox
  ];

  xdg.mime.defaultApplications = {
    "text/html" = ["firefox.desktop"];
    "text/xml" = ["firefox.desktop"];
    "application/pdf" = ["firefox.desktop"];
    "x-scheme-handler/http" = ["firefox.desktop"];
    "x-scheme-handler/https" = ["firefox.desktop"];
  };
}
