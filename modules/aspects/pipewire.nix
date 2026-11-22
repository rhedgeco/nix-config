{
  den.aspects.pipewire = {
    homeManager = { ... }: {
      persist.dirs = [
        # persist user sound and mic settings
        ".local/state/wireplumber"
      ];
    };

    nixos = { pkgs, ... }: {
      # enable rtkit
      # allows Pipewire to use the realtime scheduler for increased performance.
      # this is useful in audio production scenarios, but is normally optional
      security.rtkit.enable = true;

      environment.systemPackages = with pkgs; [
        pavucontrol
        # add crosspipe package for custom audio routing
        crosspipe
        # include pipewire jack package
        # provides access to pw-jack utility
        # to help launch jack dependent apps
        pipewire.jack
      ];

      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
      };
    };
  };
}
