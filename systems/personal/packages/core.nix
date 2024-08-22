{pkgs, ...}: {
  imports = [
    # import home-manager and impermanence
    inputs.home-manager.nixosModules.home-manager
    inputs.impermanence.nixosModules.impermanence
  ];

  # set up core packages
  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
  ];
}
