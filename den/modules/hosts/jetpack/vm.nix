{
  den.aspects.jetpack.nixos = {
    # niri (smithay) needs a GL/GLES render node, which the default std VGA
    # doesn't provide. Give the VM a virgl-capable virtio GPU instead.
    virtualisation.vmVariant.virtualisation.qemu.options = [
      "-vga none"
      "-device virtio-vga-gl"
      "-display gtk,gl=on"
    ];

    # ensure mesa's DRI drivers land on /run/opengl-driver so EGL/GBM in the
    # guest can find the virgl driver
    virtualisation.vmVariant.hardware.graphics.enable = true;
  };
}
