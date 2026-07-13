lib: {
  # get the path of all nix files at `path`
  nixPaths = path: let
    # collect all the files and directories at 'path'
    pathChildren = builtins.readDir path;

    # filter the children to only include nix modules
    nixChildren = lib.attrNames (lib.filterAttrs (
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
      pathChildren);
  in
    map (name: path + "/${name}") nixChildren;
}
