# Wrapper around Home Manger for standardizing
# on user setup across systems

{
  stateVersion,
  config,
  lib,
  inputs,
  pkgs,
  ...
}:

{
  # Configurations for this module
  options = {
    custom-home-manager = {
      enable = lib.mkEnableOption {
        description = "Enable Custom Home Manager";
        default = false;
      };
    };

    user = lib.mkOption {
      description = "Primary user of the system";
      type = lib.types.str;
    };

    # Home-Manager needs this, so just pass it along
    stateVersion = lib.mkOption {
      description = "The initial NixOS version of this system. DON'T change after initialization";
      type = lib.types.str;
    };
  };

  config = lib.mkIf (config.custom-home-manager.enable) { 
    home-manager = {
      # Documentation
      # https://nix-community.github.io/home-manager/index.xhtml
      useGlobalPkgs = true;
      useUserPackages = true;

      users.${config.user} = {pkgs, ...}: {
        home.stateVersion = config.stateVersion;

        programs = {
          # Prompt configurations
          starship = {
            # Documentation https://starship.rs/config/
            enable = true;
            settings.format = lib.concatStrings [
              "$directory"
              "$git_branch"
            ];
          };
        };
      };
    };
  };
}
