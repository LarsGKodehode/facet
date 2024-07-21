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

    # VS Code Server
    vscode-server = {
      url = "github:nix-community/nixos-vscode-server";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Patches binaries with reliance on dynamically linked libraries 
    nix-ld-rs = {
      url = "github:nix-community/nix-ld-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, ... }@inputs:
  let
    # Helper function for generating an attribute set
    allSupportedSystems = [ "x86_64-linux" ];
    forAllSystems = nixpkgs.lib.genAttrs allSupportedSystems; 
  in
  {
    # These are the specific host systems that are defined
    nixosConfigurations = {
      weasel = import ./hosts/weasel { inherit inputs; };
    };

    devShells = forAllSystems (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        default = pkgs.mkShell {
          buildInputs = [
            pkgs.git
          ];
        };
      }
    ); 
  };
}
