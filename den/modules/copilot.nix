{...}: {
  den.aspects.copilot = {
    persist-home.directories = [
      ".config/github-copilot"
    ];

    homeManager = {pkgs, ...}: {
      home.packages = [pkgs.github-github-copilot-cli];
    };
  };
}
