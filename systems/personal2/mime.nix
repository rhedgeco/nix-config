{...}: {
  xdg.mime = {
    # install files to support the XDG Shared MIME-info specification and the XDG MIME Applications specification.
    enable = true;

    # set the mime type default applications
    defaultApplications = {
      # use firefox as default for PDFs
      "application/pdf" = "firefox.desktop";
    };
  };
}
