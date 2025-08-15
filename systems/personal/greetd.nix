{pkgs, ...}: let
  session = "${pkgs.niri}/bin/niri-session";
  tuigreet = "${pkgs.greetd.tuigreet}/bin/tuigreet";
in {
  services.greetd = {
    enable = true;
    settings = {
      # autologin ryan as the user
      initial_session = {
        command = "${session}";
        user = "ryan";
      };

      # when logging out show a tuigreet prompt instead
      default_session = {
        command = "${tuigreet} --greeting 'Welcome to NixOS!' --asterisks --remember --remember-user-session --time -cmd ${session}";
        user = "greeter";
      };
    };
  };
}
