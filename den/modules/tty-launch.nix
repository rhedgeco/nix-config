let
  tty-launch-module = command: {...}: {
    programs.fish.loginShellInit = ''
      if test (tty) = /dev/tty1
        exec ${command}
      end
    '';
  };

  __functor = _self: command: {
    name = "tty-launch(${command})";
    homeManager = tty-launch-module command;
  };
in {
  den.aspects.tty-launch = {
    inherit __functor;
  };
}
