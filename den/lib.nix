lib: {
  # convenience function for evaluating options
  # uses module system to validate configuration settings
  evalOptions = options: config:
    (lib.evalModules {
      modules = [{inherit options config;}];
    }).config;
}
