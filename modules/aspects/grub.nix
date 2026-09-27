{ lib, ... }: {
  den.aspects.grub.nixos = { pkgs, config, ... }: {
    options.den.grub.skipUUID = lib.mkOption {
      description = "UUIDs to skip when scanning for drives at boot";
      type = with lib.types; listOf str;
      default = [ ];
    };

    config = {
      # skip empty uuids by default
      den.grub.skipUUID = [ "" ];

      # set up bootloader
      boot.loader = {
        timeout = lib.mkDefault 3;
        efi.canTouchEfiVariables = true;
        grub = {
          enable = true;
          efiSupport = true;
          device = "nodev";

          # theming
          splashImage = ./_assets/grub/splash.png;
          theme = pkgs.stdenv.mkDerivation {
            pname = "grub-solstice";
            version = "0.1.0";
            src = ./_assets/grub/solstice-theme;
            installPhase = ''
              runHook preInstall

              mkdir -p $out/
              cp -r ./* "$out/"

              runHook postInstall
            '';
          };

          # set up gub modules and function for skipping uuids
          extraConfig =
            let
              skipUUID = uuid: ''if [ "''${prober_uuid}" = "${lib.toUpper uuid}" ]; then prober_skip=1; fi'';
              skipUUIDS = lib.concatMapStringsSep "\n" skipUUID config.den.grub.skipUUID;
            in
            ''
              insmod regexp
              insmod probe
              insmod search
              insmod part_gpt
              insmod part_msdos
              insmod fat

              # sets prober_skip=1 if the current prober_uuid is known
              function prober_should_skip {
                  prober_skip=0
                  ${skipUUIDS}
              }
            '';

          # boot-time detection of other bootable drives.
          #
          # iterate over every partition grub can see. the (*,gpt*)/(*,msdos*)
          # wildcards expand to each matching partition device (e.g. (hd1,gpt1)).
          # when a wildcard matches nothing grub leaves the literal string
          # unexpanded, so we guard each iteration with a probe: it only sets
          # prober_uuid on a real filesystem. unlike `search`, which returns
          # only the FIRST match, this yields one entry per bootable drive.
          extraEntries = ''
            for prober_dev in (*,gpt*) (*,msdos*); do
                prober_uuid=""
                probe --set=prober_uuid --fs-uuid "$prober_dev"
                if [ -n "$prober_uuid" ]; then
                    prober_should_skip
                    if [ "$prober_skip" = 0 ]; then
                        # windows bootloader
                        if [ -e "$prober_dev/EFI/Microsoft/Boot/bootmgfw.efi" ]; then
                            menuentry "Windows $prober_dev" "$prober_dev" --class windows11 --class windows --class os {
                                insmod part_gpt
                                insmod part_msdos
                                insmod fat
                                insmod chain
                                set root="$2"
                                chainloader /EFI/Microsoft/Boot/bootmgfw.efi
                            }
                        # generic removable EFI bootloader
                        elif [ -e "$prober_dev/EFI/BOOT/BOOTX64.EFI" ]; then
                            menuentry "Boot $prober_dev" "$prober_dev" --class os {
                                insmod part_gpt
                                insmod part_msdos
                                insmod fat
                                insmod chain
                                set root="$2"
                                chainloader /EFI/BOOT/BOOTX64.EFI
                            }
                        fi
                    fi
                fi
            done
          '';
        };
      };
    };
  };
}
