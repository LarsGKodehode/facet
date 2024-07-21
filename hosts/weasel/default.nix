# The Weasel
# System configuration for the basic WSL instance

{
  inputs,
}:

let
  system = "x86_64-linux";
  hostName = "weasel";
  globals = rec {
    stateVersion = "24.05";
    user = "zab";
    gitName = "zabronax";
    gitEmail = "104063134+LarsGKodehode@users.noreply.github.com";

    nixConfigurationsPath = builtins.toPath ("/home/${user}" + "/.systems");
  };
in
inputs.nixpkgs.lib.nixosSystem {
  system = system;
  modules = [
    globals
    ../../modules/common

    # TODO Figure out how to coalesce the home-manager configurations
    ../../modules/home-manager
    inputs.home-manager.nixosModules.home-manager

    # TODO find a way to move this to it's own module 
    inputs.vscode-server.nixosModules.default

    # Host specific configurations
    ../../modules/wsl
    inputs.nixos-wsl.nixosModules.wsl
    ({ config, inputs, pkgs, ... }: {
      # NixOS Configurations
      system.stateVersion = config.stateVersion; # Initial version of NixOS for this system
      nix.settings.experimental-features = "nix-command flakes"; # Enables flakes for this system

      networking.hostName = hostName; 

      # Program and service modules
      custom-home-manager.enable = true;
      editors.vscode-server.enable = true;

      # WSL specific configurations
      wsl = {
        # Documentation
        # https://nix-community.github.io/NixOS-WSL/
        enable = true;

	defaultUser = config.user;

        wslConf.network.generateResolvConf = true; # Turn off if it breaks VPN
	interop.includePath = false; # Slows down some shell operations due to filesystem boundary
      };
    })
  ];
}
