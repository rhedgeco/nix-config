{lib, ...}: {
  den.default = {
    homeManager = {
      pkgs,
      config,
      ...
    }: let
      mkSessionFiles = name: cfg: {
        ".sessions/${name}/packages".source = pkgs.buildEnv {
          name = "${name}-session-packages";
          paths = cfg.packages;
        };

        ".sessions/${name}/env.sh".source =
          pkgs.writeShellScript "${name}-env"
          (lib.concatStringsSep "\n"
            (lib.mapAttrsToList (k: v: "export ${k}=${lib.escapeShellArg v}") cfg.env));

        ".sessions/${name}/init.sh".source = pkgs.writeShellScript "${name}-init" cfg.init;
        ".sessions/${name}/run.sh".source = pkgs.writeShellScript "${name}-run" cfg.run;
      };
    in {
      options.sessions = lib.mkOption {
        default = {};
        description = "Composable session parts that can be loaded by desktop environments";
        type = with lib.types;
          attrsOf (submodule {
            options.packages = lib.mkOption {
              default = [];
              description = "Packages available in this session";
              type = listOf package;
            };

            options.env = lib.mkOption {
              default = {};
              description = "Environment variables for this session";
              type = attrsOf str;
            };

            options.init = lib.mkOption {
              default = "";
              description = "Shell commands to run during session initialization, before the compositor starts";
              type = lines;
            };

            options.run = lib.mkOption {
              default = "";
              description = "Shell commands run by the compositor after it has started";
              type = lines;
            };
          });
      };

      config.home.file =
        lib.mkMerge (lib.mapAttrsToList mkSessionFiles config.sessions);
    };
  };
}
