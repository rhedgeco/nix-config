{
  den.aspects.jetpack.nixos = {
    pkgs,
    config,
    ...
  }: let
    # to discover these values run `lspci -nnD | grep -E -i "vga|3d|display"`
    igpu-address = "0000:c1:00.0";
    egpu-id = "10de:2488";
    egpu-timeout = 5; # seconds to wait for the eGPU to appear
    unbind-timeout = 15; # seconds to keep retrying the unbind at boot
  in {
    # create a service that unbinds the internal gpu if the egpu is detected at startup
    systemd.services.unbind-internal-gpu = {
      description = "Detect and configure eGPU";

      serviceConfig = {
        Type = "oneshot";
        # ensure the service stays up after it exits
        # this prevents the service from running again on `nixos-rebuild switch`
        RemainAfterExit = true;

        # no sandboxing: this runs as root and writes host sysfs directly
      };

      # Wait for Thunderbolt daemon to authorize devices first
      wants = ["bolt.service"];
      after = ["bolt.service"];

      # run is wanted by the graphical target,
      # but has to start before the display-manager
      # this ensures nothing is using the internal gpu when we unbind it
      wantedBy = ["graphical.target"];
      before = ["display-manager.service"];

      script = ''
        echo "checking for eGPU '${egpu-id}'..."

        # wait for the eGPU to appear (bolt may still be authorizing it)
        egpu_present=0
        for i in $(seq 1 ${toString egpu-timeout}); do
          if ${pkgs.pciutils}/bin/lspci -d "${egpu-id}" | grep -q .; then
            egpu_present=1
            break
          fi
          echo "eGPU not found, trying again..."
          sleep 1
        done

        if [ "$egpu_present" -ne 1 ]; then
          echo "eGPU not detected after ${toString egpu-timeout}s, proceeding with iGPU."
          exit 0
        fi

        echo "eGPU detected."

        # nothing to do if the iGPU is not bound to amdgpu
        if [ ! -d "/sys/bus/pci/drivers/amdgpu/${igpu-address}" ]; then
          echo "iGPU '${igpu-address}' is not bound to amdgpu, nothing to unbind."
          exit 0
        fi

        # during early boot the kernel briefly refuses the unbind (EACCES) while
        # amdgpu is still settling as the primary console device. it succeeds a
        # moment later, so retry the write on a fixed interval until it takes.
        echo "unbinding iGPU at '${igpu-address}'..."
        for i in $(seq 1 ${toString unbind-timeout}); do
          if echo "${igpu-address}" > "/sys/bus/pci/drivers/amdgpu/unbind" 2>/dev/null; then
            echo "successfully unbound ${igpu-address} from amdgpu."
            exit 0
          fi
          sleep 1
        done

        echo "failed to unbind ${igpu-address} after ${toString unbind-timeout}s, proceeding with iGPU."
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
