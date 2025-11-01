{lib, ...}: {
  mkDefaultHomeService = {
    description,
    script,
    restart ? false,
    custom ? {},
  }:
    {
      Unit.Description = description;

      Service = {
        Restart = lib.mkIf restart "on-failure";
        ExecStart = script;
      };

      Install = {
        WantedBy = ["default.target"];
      };
    }
    // custom;
}
