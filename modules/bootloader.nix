{lib, ...}: {
  options.custom.bootloader = {
    enable = lib.mkOption {
      type = lib.types.enum ["grub"];
      description = "Select which bootloader to use.";
    };
  };
}
