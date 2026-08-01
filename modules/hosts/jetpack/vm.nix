{
  den.aspects.jetpack.nixos.virtualisation.vmVariant = {
    # enable hardware accelerated graphics
    hardware.graphics.enable = true;

    # the VM root is a tmpfs and there is no MAIN-labeled btrfs disk
    # without this the initrd hangs forever waiting on that device unit
    boot.initrd.systemd.services.wipe-btrfs-root.enable = false;

    virtualisation = {
      # use a tmpfs disk image
      diskImage = null;

      # give enough memory so some apps dont have to swap
      memorySize = 8192;

      # set up persistent disk so stores dont fail
      # this is still on the tmpfs and will not actually persist
      fileSystems."/persist" = {
        device = "tmpfs";
        fsType = "tmpfs";
        options = [ "mode=755" ];
        neededForBoot = true;
      };

      qemu.options = [
        "-cpu host"
        "-enable-kvm"

        # niri (smithay) needs a GL/GLES render node
        # proivide the VM a virgl-capable virtio GPU
        "-vga none"
        "-device virtio-vga-gl"
        "-display gtk,gl=on,grab-on-hover=on"
      ];
    };
  };
}
