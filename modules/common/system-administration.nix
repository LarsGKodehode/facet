{
  config,
  lib,
  pkgs,
  environment,
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
    environment.systemPackages = [ 
      pkgs.htop # Display system processes
    ];
  };
}
