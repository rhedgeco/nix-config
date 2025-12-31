{...}: {
  # set up ryande monitors for this host
  igloo.modules.scrollde.outputs = {
    # laptop monitor
    "eDP-1" = {
      scale = 1.8;
    };

    # super-ultrawide monitor
    "Samsung Electric Company C49RG9x H1AK500000" = {
      mode = "5120x1440@119.970";
    };
  };
}
