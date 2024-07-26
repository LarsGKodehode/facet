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

      # Capabilities (Programs, Services, etc) 
      custom-home-manager.enable = true;
      system-administration.enable = true;
      editors.vscode-server.enable = true;
      editors.neovim.enable = true;

      # WSL specific configurations
      wsl = {
        # Documentation
        # https://nix-community.github.io/NixOS-WSL/
        enable = true;

	defaultUser = config.user;

        wslConf.network.generateResolvConf = true; # Turn off if it breaks VPN

        # TODO Figure out how to turn this into an allow list, over a blanket include statement
        # the problem lies in figuring out the exact paths of the binaries
        # wsl.includeBin can do the rest
        #
        # This appends windows PATH to the WSL PATH which might cause slowdowns in commands
        # (likly due to them doing a recursive search of all entries in PATH)
        # enabling it for now to allow usage of some Windows binaries inside WSL
        #
        # Required for:
        # - 1Password CLI
        interop.includePath = true;
      };

      # 1Password "integrations"
      # since 1Password does not currently support plugins in Windows
      # https://github.com/1Password/shell-plugins/issues/402
      #
      # The simplest integration, for applications that supports environment secrets
      # is to just to wrap them with this, mind it's likely to incure some performance
      # penalties, along with requiring all calls to be authenticated, so limit this
      # to those cases where this is likely to not make too much of a difference
      home-manager.users.${config.user}.programs.fish.functions = {
        github = {
          description = "Authenticated GitHub CLI commands";
          body = ''
            set --local --export GH_TOKEN '$(op read \"op://Personal/GitHub Zabronax/personal-access-token\")'
            command gh $argv
          '';
          wraps = "gh"; # Inherit suggestions from the GitHub CLI
        };
      };
    })
  ];
}
