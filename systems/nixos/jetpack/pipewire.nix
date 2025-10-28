{pkgs, ...}: {
  # enable rtkit
  # allows Pipewire to use the realtime scheduler for increased performance.
  # this is useful in audio production scenarios, but is normally optional
  security.rtkit.enable = true;

  environment.systemPackages = with pkgs; [
    # add qpwgraph package for custom audio routing
    qpwgraph
  ];

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;

    # enables the `pipewire-jack` compatability
    # allows apps that use `jack` to work with pipewire
    jack.enable = true;
  };
}
