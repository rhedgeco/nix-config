lib: {
  # get all the names of nix modules under 'path'
  nixModuleNames = path:
    lib.map (info: info.name)
    (lib.custom.read.nixModuleInfo path);

  # get all the paths of nix modules under 'path'
  nixModulePaths = path:
    lib.map (info: info.path)
    (lib.custom.read.nixModuleInfo path);

  # get all the info of nix modules under 'path'
  # WARNING - this is the only function depended on by the custom lib root
  # this function can not depend on any other custom functions
  # if it did, it would create recursion problems at the custom lib root
  nixModuleInfo = path: let
    # collect all the files and directories at 'path'
    pathChildren = builtins.readDir path;

    # filter the children to only include nix modules
    nixChildren =
      lib.filterAttrs (
        fileName: fileType:
          (
            # if the path is a directory, ensure it contains a `default.nix` file
            fileType == "directory" && builtins.pathExists (path + "/${fileName}/default.nix")
          )
          || (
            # if the path is a file, make sure it ends with a `.nix` extension
            # we also exclude `default.nix` here since importing it is almost always a mistake
            fileType == "regular" && lib.hasSuffix ".nix" fileName && fileName != "default.nix"
          )
      )
      pathChildren;

    # map the nix files and generate information about the module
    moduleInfo =
      lib.mapAttrsToList (fileName: fileType: {
        # create the nix module path
        # the module path is just the filename appended to the root path
        path = path + "/${fileName}";

        # create the nix module name
        # if the module is a file, the '.nix' suffix has to be stripped
        # otherwise if its a folder, the filename should be sufficient
        name =
          if fileType == "regular"
          then lib.removeSuffix ".nix" fileName
          else fileName;
      })
      nixChildren;
  in
    moduleInfo;
}
