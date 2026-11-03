{
  den.aspects.local-bin.homeManager = { config, lib, ... }: {
    # add ~/.local/bin to the PATH so any binary dropped in here is resolvable
    home.sessionPath = [ "${config.home.homeDirectory}/.local/bin" ];

    # ensure the directory exists and is writable
    home.activation.localBin = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      run mkdir -p "${config.home.homeDirectory}/.local/bin"
    '';
  };
}
