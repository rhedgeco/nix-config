{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    rustup
    gcc
  ];

  environment.persistence."/persist".users.ryan = {
    directories = [
      ".rustup"
    ];
  };
}
