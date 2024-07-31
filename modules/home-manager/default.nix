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
  imports = [
    ./shell
    ./editors
  ];

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

    theme = {
      colors = lib.mkOption {
        description = "Base16 color scheme";
        type = lib.types.attrs;
        default = (import ../colorschemes/gruvbox).dark;
      };

      dark = lib.mkOption {
        description = "Enable dark mode";
        type = lib.types.bool;
        default = true;
      };
    };
  };

  config = lib.mkIf (config.custom-home-manager.enable) { 
    home-manager = {
      # Documentation
      # https://nix-community.github.io/home-manager/index.xhtml
      useGlobalPkgs = true;
      useUserPackages = true;

      users.${config.user}.home.stateVersion = config.stateVersion;
      users.root.home.stateVersion = config.stateVersion;
    };
  };
}
