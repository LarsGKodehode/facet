{
  pkgs,
  config,
  lib,
  ...
}:

{
  options = {
    editors.vscode-server = {
      enable = lib.mkEnableOption {
        description = "Enable VS Code Server";
        default = false;
      };
    };
  };

  config = lib.mkIf (config.editors.vscode-server.enable) {
    # The VS Code Server needs to be patched due to it's
    # reliance on dynamically linked binaries
    programs.nix-ld = {
      enable = true;
      package = pkgs.nix-ld-rs;
    };

    services.vscode-server.enable = true;
  };
}
