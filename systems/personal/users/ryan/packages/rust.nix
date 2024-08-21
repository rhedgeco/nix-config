{...}: {
  # persist rustup data
  home.persistence."/persist/home/ryan" = {
    allowOther = true;
    directories = [
      ".rustup"
    ];
  };
}
