let
  autologin-module = user: command: {pkgs, ...}: {
    services.greetd = {
      enable = true;
      settings = {
        initial_session = {
          inherit user command;
        };
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --greeting 'Welcome to NixOS!' --asterisks --remember --remember-user-session --time --cmd '${command}'";
          user = "greeter";
        };
      };
    };
  };

  __functor = _self: user: command: {
    name = "autologin(${user}:${command})";
    nixos = autologin-module user command;
  };
in {
  den.aspects.autologin = {
    inherit __functor;
  };
}
