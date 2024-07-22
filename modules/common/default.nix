# Configurations shared by all systems

{
  pkgs,
  ...
}:

{
  imports = [
    ./system-administration.nix
  ];

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
