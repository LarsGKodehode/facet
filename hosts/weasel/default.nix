# The Weasel
# System configuration for the basic WSL instance

{
  inputs,
  globals,
  # Disabling unlisted dependencies to better understand when it breaks 
  #...
}:

let
  hostName = "weasel";
in
inputs.nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  modules = [
    inputs.nixos-wsl.nixosModules.wsl
    {
      # The initial version of NixOS installed
      # used in as part of system migrations 
      # TODO figure out where to best define this
      system.stateVersion = "24.05";

      networking.hostName = hostName; 

      wsl = {
        # Documentation
        # https://nix-community.github.io/NixOS-WSL/
        enable = true;

	defaultUser = globals.user;

        wslConf.network.generateResolvConf = true; # Turn off if it breaks VPN
	interop.includePath = false; # Slows down some shell operations due to filesystem boundary
      };

      nix.settings.experimental-features = "nix-command flakes";
    }
  ];
}
