{inputs, ...}: {
  den.aspects.noctalia.homeManager = {pkgs, ...}: {
    home.packages = [
      inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];

    persist.files = [
      # contains calendar and other state that should persist
      ".local/state/noctalia/state.toml"
    ];

    # set sensible defaults for noctalia here
    create.".config/noctalia/den.toml" = ''
      [general]
      show_welcome = false
    '';
  };
}
