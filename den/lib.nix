lib: {
  evalOptions = options: config: let
    modules = {modules = [{inherit options config;}];};
  in
    (lib.evalModules modules).config;
}
