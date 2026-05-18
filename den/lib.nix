lib: {
  # convenience function for evaluating options
  # uses module system to validate configuration settings
  evalOptions = options: config: let
    modules = {modules = [{inherit options config;}];};
  in
    (lib.evalModules modules).config;
}
