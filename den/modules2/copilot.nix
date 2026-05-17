{
  den.aspects.copilot = {
    homeManager = {pkgs, ...}: {
      home.packages = [pkgs.github-github-copilot-cli];
      persist.directories = [".config/github-copilot"];
    };
  };
}
