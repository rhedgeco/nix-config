{inputs, ...}: {
  # initialize user
  users.users = {
    ryan = {
      isNormalUser = true;
      useDefaultShell = true;
      initialPassword = "ryan";
      extraGroups = ["wheel" "networkmanager"];
    };
  };

  # set up home manager
  home-manager = {
    extraSpecialArgs = {inherit inputs;};
    users.ryan = import ./home.nix;
  };

  # persist only certain user data
  environment.persistence."/persist".users.ryan = {
    directories = [
      "Downloads"
      "Music"
      "Pictures"
      "Documents"
      "Videos"
      ".mozilla"
      ".rustup"
      {
        directory = ".gnupg";
        mode = "0700";
      }
      {
        directory = ".ssh";
        mode = "0700";
      }
      {
        directory = ".local/share/keyrings";
        mode = "0700";
      }

      # persist certain folders until dotfiles are set up
      ".config/dconf"
    ];
    files = [
      ".config/monitors.xml"
    ];
  };
}
