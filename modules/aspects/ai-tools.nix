{ inputs, ... }: {
  den.aspects.ai-tools = {

    homeManager = { pkgs, ... }: {
      home.packages = [
        inputs.hermes-agent.packages.${pkgs.stdenv.hostPlatform.system}.default
        pkgs.ollama-cuda
      ];
    };
  };
}
