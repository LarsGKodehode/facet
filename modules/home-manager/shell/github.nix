{
  config,
  lib,
  home-manager,
  ...
}:

{
  home-manager.users.${config.user} = {
    # Only enable the github cli if git is enabled for the user
    programs.gh = lib.mkIf (config.home-manager.users.${config.user}.programs.git.enable) {
      enable = true;
      gitCredentialHelper.enable = true;
      settings.git_protocol = "ssh";
    };
  };
}
