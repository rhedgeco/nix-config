inputs: let
  # get the lib from nixpkgs
  lib = inputs.nixpkgs.lib;

  # a function that imports a library file
  # lib.flip 'flips' the import and inherit block arguments
  # this essentially preloads the arguments for any path that gets called
  importLib = lib.flip import {inherit lib iglib inputs;};

  # create a function that gets the path of every nix module at a path
  # also assert that the path provided is a directory instead of a file
  findModules = path: let
    # read all the files from the provided directory
    pathChildren = builtins.readDir path;

    # filter the directory content to only nix modules
    moduleNames = lib.attrNames (
      lib.filterAttrs (
        fileName: fileType:
        # if the path is a directory, make sure it contains a `default.nix` file
          (fileType == "directory" && builtins.pathExists (path + "/${fileName}/default.nix"))
          # if the path is a file, make sure it ends with a `.nix` extension
          # we also exclude `default.nix` here since importing it is almost always a mistake
          || (fileType == "regular" && lib.hasSuffix ".nix" fileName && fileName != "default.nix")
      )
      pathChildren
    );

    # then map the module names to a list of paths
    modulePaths = lib.map (name: path + "/${name}") moduleNames;
  in
    modulePaths;

  # find all the library modules in the current directory
  libModulePaths = findModules ./.;

  # import all the library content into a list of attribute sets
  libModuleContent = lib.map (path: importLib path) libModulePaths;

  # collect and fold all library content into a single library attribute set
  iglib = (builtins.foldl' (acc: elem: acc // elem) {} libModuleContent) // {inherit findModules;};
in
  iglib
