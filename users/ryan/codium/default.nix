{...}: {
  # create the codium settings json file
  home.file.".config/VSCodium/User/settings.json" = {
    text = builtins.readFile ./settings.json;
    force = true;
  };
}
