{den, ...}: {
  den.aspects.bambu = {
    includes = [den.aspects.flatpak];
    homeManager.persist.dirs = [
      ".var/app/com.bambulab.BambuStudio"
    ];
  };
}
