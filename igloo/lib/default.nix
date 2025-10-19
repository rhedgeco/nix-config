inputs: let
  # get the lib from nixpkgs
  lib = inputs.nixpkgs.lib;

  # create a function that gets the path of every nix module at a path
  # also assert that the path provided is a directory instead of a file
  getModulePaths = path: let
    # read all the files from the provided directory
    dirContent = builtins.readDir path;

    # filter the directory content to only nix modules
    moduleNames = lib.attrNames (
      lib.filterAttrs (
        fileName: fileType:
        # if the path is a directory, make sure it contains a `default.nix` file
          (fileType == "directory" && builtins.pathExists (path + "/${fileName}/default.nix"))
          # if the path is a file, make sure it ends with a `.nix` extension
          # we also exclude `default.nix` here since importing it is probably a mistake
          || (fileType == "regular" && lib.hasSuffix ".nix" fileName && fileName != "default.nix")
      )
      dirContent
    );

    # then map the module names to a list of paths
    modulePaths = lib.map (name: path + "/${name}") moduleNames;
  in
    modulePaths;

  # use the getModulePaths function get all other modules in the lib
  libModulePaths = getModulePaths ./.;

  # import all the modules content
  libModuleContent = lib.map (path: import path) libModulePaths;

  # merge those modules for the final re-export
  mergedLibModules = lib.mkMerge libModuleContent;
in
  # re-export all lib modules and the getModulePaths function
  mergedLibModules // {inherit getModulePaths;}
