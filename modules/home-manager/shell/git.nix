{
  config,
  lib,
  home-manager,
  ...
}:

{
  options = {
    gitName = lib.mkOption {
      description = "Name to use for git commits";
      type = lib.types.str;
    };
    gitEmail = lib.mkOption {
      description = lib.mkOption {
        description = "Email to use for git commits";
        type = lib.types.str;
      };
    };
  };

  config = {
    home-manager.users.root.programs.git.enable = true;

    home-manager.users.${config.user} = {
      programs.git = {
        enable = true;
        userName = config.gitName;
        userEmail = config.gitEmail;

        extraConfig = {
          init.defaultBranch = "main";
          push.autoSetupRemote = true;
        };
      };

      # Shell integration
      programs.fish.shellAbbrs = {
        gs = "git status";
        gd = "git diff";
        gdp = "git diff HEAD^";
        ga = "git add";
        gaa = "git add -A";
        gu = "git pull";
        gp = "git push";
        cdg = "cd (git rev-parse --show-toplevel)";
        gc = "git commit --message";
        gca = "git commit --amend --no-edit";
        gcae = "git commit --amend";
      };
    };
  };
}
