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
    ];
    files = [
      ".config/monitors.xml"
      ".zsh_history"
    ];
  };
}
