{
  den.aspects.jetpack.nixos = {
    pkgs,
    config,
    ...
  }: let
    # to discover these values run `lspci -nnD | grep -E -i "vga|3d|display"`
    igpu-address = "0000:c1:00.0";
    egpu-id = "10de:2488";
    egpu-timeout = 5; # seconds
  in {
    # create a service that unbinds the internal gpu if the egpu is detected at startup
    systemd.services.unbind-internal-gpu = {
      description = "Detect and configure eGPU";
      # prevent nixos-rebuild switch from re-running this service
      # since unbinding a GPU while a compositor is running would be destructive
      restartIfChanged = false;

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };

      # run is wanted by the graphical target,
      # but has to start before the display-manager
      # this ensures nothing is using the internal gpu when we unbind it
      wantedBy = ["graphical.target"];
      before = ["display-manager.service"];

      script = ''
        echo "checking for eGPU '${egpu-id}'..."
        # Loop for up to ${toString egpu-timeout} seconds.
        for i in $(${pkgs.coreutils}/bin/seq 1 ${toString egpu-timeout}); do
          # Use lspci to check if the eGPU's PCI ID is present
          if ${pkgs.pciutils}/bin/lspci -d "${egpu-id}" | ${pkgs.gnugrep}/bin/grep -q .; then
            echo "eGPU detected, unbinding iGPU at '${igpu-address}'..."
            # Unbind the iGPU driver (the quotes are important)
            echo "${igpu-address}" > "/sys/bus/pci/drivers/amdgpu/unbind" 2>/dev/null
            if [ -e "/sys/bus/pci/drivers/amdgpu/${igpu-address}" ]; then
              echo "iGPU unbind failed, it may still be in use" | systemd-cat -p warning -t egpu
            else
              echo "iGPU successfully unbound"
            fi
            exit 0
          fi
          # Wait one second before checking again.
          echo "eGPU not found trying again..."
          ${pkgs.coreutils}/bin/sleep 1
        done

        echo "eGPU not detected after ${toString egpu-timeout}s, proceeding with iGPU."
        exit 0
      '';
    };

    # Enable OpenGL
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    # support nvidia video drivers
    services.xserver.videoDrivers = ["nvidia"];

    # set up nvidia hardware
    hardware.nvidia = {
      # Modesetting is required.
      modesetting.enable = true;

      # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
      # Enable this if you have graphical corruption issues or application crashes after waking
      # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
      # of just the bare essentials.
      powerManagement.enable = false;

      # Fine-grained power management. Turns off GPU when not in use.
      # Experimental and only works on modern Nvidia GPUs (Turing or newer).
      powerManagement.finegrained = false;

      # Use the NVidia open source kernel module (not to be confused with the
      # independent third-party "nouveau" open source driver).
      # Support is limited to the Turing and later architectures. Full list of
      # supported GPUs is at:
      # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
      # Only available from driver 515.43.04+
      # Currently alpha-quality/buggy, so false is currently the recommended setting.
      open = false;

      # Enable the Nvidia settings menu,
      # accessible via `nvidia-settings`.
      nvidiaSettings = true;

      # Optionally, you may need to select the appropriate driver version for your specific GPU.
      package = config.boot.kernelPackages.nvidiaPackages.beta;
    };

    # ignore lid switches when plugged into a power source
    services.logind.settings.Login.HandleLidSwitchExternalPower = "ignore";
  };
}
