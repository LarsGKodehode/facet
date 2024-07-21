# Configurations shared by all systems

{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [];

  options = {};

  config = {
    # Always enabled packages
    environment.systemPackages = [
      pkgs.git
      pkgs.vim
      pkgs.curl
      pkgs.wget
    ];
  };
}
