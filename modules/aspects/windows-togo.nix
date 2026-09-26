{
  den.aspects.windows-togo = name: uuid: {
    nixos = {
      # set the hardware clock to local time to play nicely with windows
      time.hardwareClockInLocalTime = true;

      # only define the grub entry when the windows togo drive is plugged in
      boot.loader.grub.extraConfig = ''
        if search --no-floppy --fs-uuid --set=root ${uuid}; then
            menuentry "${name}" --class windows11 --class windows --class os --id windows-togo-${uuid} {
                insmod part_gpt
                insmod part_msdos
                insmod fat
                insmod search_fs_uuid
                insmod chain
                search --no-floppy --fs-uuid --set=root ${uuid}
                chainloader /EFI/Microsoft/Boot/bootmgfw.efi
            }
        fi
      '';
    };
  };
}
