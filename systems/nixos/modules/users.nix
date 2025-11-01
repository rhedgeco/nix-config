{
  lib,
  inputs,
  ...
}: let
  iglib = inputs.igloo.lib;

  # get all the user names in the user directory
  userDir = ../../../users;
  userNames = lib.attrNames (
    lib.filterAttrs (
      fileName: fileType:
        fileType == "directory" && fileName != "modules"
    ) (builtins.readDir userDir)
  );

  # collect all user modules
  userModules = iglib.findModules (userDir + "/modules");
  userNameModules = lib.map (name:
    iglib.mkUserModule {
      inherit name;
      modules = userModules ++ (iglib.findModules (userDir + "/${name}"));
    })
  userNames;
in {
  imports = userNameModules;
}
