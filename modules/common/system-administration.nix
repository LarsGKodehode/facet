{
  config,
  lib,
  pkgs,
  ...
}:

{
  options = {
    system-administration = {
      enable = lib.mkEnableOption {
        description = "Enable system administration tools";
        default = false;
      };
    };
  };

  config = lib.mkIf (config.system-administration.enable) {
    home-manager.users.${config.user}.home.packages = [
      pkgs.htop # Display system processes
    ];
  };
}
