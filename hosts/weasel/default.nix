# The Weasel
# System configuration for the basic WSL instance

{
  inputs,
}:

let
  hostName = "weasel";
  globals = {
    stateVersion = "24.05";
    user = "zab";
  };
in
inputs.nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";

  modules = [
    globals
    ../../modules/common

    # TODO Figure out how to coalesce the home-manager configurations
    ../../modules/home-manager
    inputs.home-manager.nixosModules.home-manager

    # Host specific configurations
    inputs.nixos-wsl.nixosModules.wsl
    ({ config, inputs, pkgs, ... }: {
      # NixOS Configurations
      system.stateVersion = "24.05"; # Initial version of NixOS for this system
      nix.settings.experimental-features = "nix-command flakes"; # Enables flakes for this system

      networking.hostName = hostName; 

      # Program and service modules
      custom-home-manager.enable = true;

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
