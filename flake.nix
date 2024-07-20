{
  description = "Entrypoint for my systems";

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
  };

  outputs = { nixpkgs, ... }@inputs:
    let
      # Global configurations for these systems
      globals = rec {
        user = "zab";
        fullName = "zabronax";
        gitName = fullName;
        gitEmail = "104063134+LarsGKodehode@users.noreply.github.com";
      };
    in
    rec {
      # These are the specific host systems that are defined
      nixosConfigurations = {
        weasel = import ./hosts/weasel { inherit inputs globals; };
      };
    };
}
