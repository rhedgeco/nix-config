{
  den.aspects.jetpack.nixos = {
    # set up the vm filesystem with everything it needs
    virtualisation.vmVariant.virtualisation = {
      diskImage = null; # tmpfs
      fileSystems."/persist" = {
        device = "tmpfs";
        fsType = "tmpfs";
        options = ["mode=755"];
        neededForBoot = true;
      };
    };

    # niri (smithay) needs a GL/GLES render node
    # proivide the VM a virgl-capable virtio GPU
    virtualisation.vmVariant.virtualisation.qemu.options = [
      "-vga none"
      "-device virtio-vga-gl"
      "-display gtk,gl=on,grab-on-hover=on"
    ];

    # enable graphics so EGL/GBM can find the virgl driver
    virtualisation.vmVariant.hardware.graphics.enable = true;
  };
}
