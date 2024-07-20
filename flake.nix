{
  description = "Entrypoint for my systems";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };

    # Community module for WSL configuration
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixos-wsl,
    ...
  }:

  {
    nixosConfigurations = {
      weasel = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
	modules = [
	  nixos-wsl.nixosModules.default
	  {
	    system.stateVersion = "24.05";
	    wsl.enable = true;
	    wsl.defaultUser = "zab";
	  }
	];
      };
    };
  };
}
