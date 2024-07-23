# Allows automatic building and entering of
# development shells on change of directories
# https://github.com/nix-community/nix-direnv
{
  config,
  home-manager,
  ...
}:

{
  home-manager.users.${config.user} = {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;

      # Always trust the nixos configuration
      config.whitelist.prefix = [ config.nixConfigurationsPath ];

      # Silence the environment variable dump due to verbosity
      # when loading or rebuilding nix-shells
      silent = true;
    };
  };
}
