inputs: let
  # get the lib from nixpkgs
  lib = inputs.nixpkgs.lib;

  # create a function that loads nix modules from a provided directory
  modulePaths = directory: let
    # read all the files from the provided directory
    dirContent = builtins.readDir directory;

    # filter the directory content to only nix modules
    nixModules = lib.attrNames (
      lib.filterAttrs (
        fileName: fileType:
        # if the path is a directory, make sure it contains a `default.nix` file
          (fileType == "directory" && builtins.pathExists (directory + "/${fileName}/default.nix"))
          # if the path is a file, make sure it ends with a `.nix` extension
          # we also exclude `default.nix` here since importing it is probably a mistake
          || (fileType == "regular" && fileName != "default.nix")
      )
      dirContent
    );

    # then map the module names to a list of paths
    modulePaths = lib.map (name: directory + "/${name}") nixModules;
  in
    modulePaths;
in {
  # export all useful functions from this module
  inherit modulePaths;
}
