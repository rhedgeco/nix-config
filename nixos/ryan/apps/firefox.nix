{
  config,
  inputs,
  ...
}: {
  imports = [
    inputs.nur.nixosModules.nur
  ];

  programs.firefox = {
    enable = true;
    profiles.default = {
      id = 0;
      name = "ryan";
      isDefault = true;
      extensions = with config.nur.repos.rycee.firefox-addons; [
        ublock-origin
        bitwarden
        darkreader
      ];
    };
  };

  xdg.enable = true;
  xdg.mimeApps.defaultApplications = {
    "text/html" = ["firefox.desktop"];
    "text/xml" = ["firefox.desktop"];
    "application/pdf" = ["firefox.desktop"];
    "x-scheme-handler/http" = ["firefox.desktop"];
    "x-scheme-handler/https" = ["firefox.desktop"];
  };
}
