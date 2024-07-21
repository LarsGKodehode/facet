{
  config,
  lib,
  ...
}:

{
  options = {
    nixConfigurationsPath = lib.mkOption {
      description = "Path to the nixos configurations repository";
    };
  };

  config = lib.mkIf (config.wsl.enable) {
    # Replace confgi directory with our repo since it's source on every launch
    system.activationScripts.configDir.text = ''
      rm -rf /etc/nixos
      ln --symbolic --no-dereference --force ${config.nixConfigurationsPath} /etc/nixos
    '';
  };
}
