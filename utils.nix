{inputs}: let
  lib = inputs.nixpkgs.lib;
in rec {
  # a function that imports the content of every file in a directory
  importDir = directory: let
    # first get all the files and folders in the directory
    dirFiles = builtins.readDir directory;

    # then import the the content for each module
    dirConfig =
      lib.mapAttrsToList (
        name: type:
          import "${directory}/${name}"
      )
      dirFiles;
  in
    dirConfig;

  # a function that builds multiple nixosSystem hosts
  buildHosts = hosts: let
    # import all the configuration in the module directory
    moduleContent = importDir ./modules;
  in
    # the buildHosts function takes in an attribute set with `name = path`
    # e.g. 'jetpack = ./path/to/jetpack.nix'
    builtins.mapAttrs (
      name: path: let
        # import the configuration from the host
        hostContent = import path;
      in
        # builds the nixosSystem for this host
        lib.nixosSystem {
          specialArgs = {inherit inputs;};
          modules =
            [
              # ensure that the hostname matches the system name
              {networking.hostName = "${name}";}
              # import the host content
              hostContent
            ]
            # import all modules into every system
            # modules should provide options to enable their config
            ++ moduleContent;
        }
    )
    hosts;
}
