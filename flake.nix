{
  description = "Entrypoint for my systems configurations";

  # This is a list of all the external dependencies of this setup
  inputs = {
    # The main packages repository for prepacked packages
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };

    # Community module for WSL configuration
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Manages user specific files and binaries
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, ... }@inputs: {
    # These are the specific host systems that are defined
    nixosConfigurations = {
      weasel = import ./hosts/weasel { inherit inputs; };
    };
  };
}
