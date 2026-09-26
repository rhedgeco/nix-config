{
  den.aspects.network = {
    # any user that needs to use the network needs to be in this group
    user.extraGroups = [ "networkmanager" ];

    nixos = { pkgs, ... }: {
      networking.networkmanager.enable = true;

      # extract just the nm-connection-editor from the applet package
      # we just need this for more advanced configuration on the system
      # desktop shells often provide their own simple wifi connection interface
      # if one needs to use the applet from the package, they can add it explicitly
      environment.systemPackages = [
        (pkgs.runCommand "nm-connection-editor-only" { } ''
          mkdir -p $out/bin $out/share/applications
          ln -s ${pkgs.networkmanagerapplet}/bin/nm-connection-editor $out/bin/nm-connection-editor
          ln -s ${pkgs.networkmanagerapplet}/share/applications/nm-connection-editor.desktop $out/share/applications/
        '')
      ];

      networking.nameservers = [
        # cloudflare
        "1.1.1.1"
        "1.0.0.1"

        # google
        "8.8.8.8"
        "8.8.4.4"
      ];

      persist.dirs = [
        # persist the network manager connections between boots
        # so you dont have to re-authenticate your wifi each time
        "/etc/NetworkManager/system-connections"
      ];
    };
  };
}
