{
  description = "Entrypoint for my systems configurations";

  # This is a list of all the external dependencies of this setup
  inputs = {
    # The main packages repository for packages definitions
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

    # MacOS Dependencies

    # Manage macOS systems through Nix
    darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew = {
      url = "github:zhaofengli-wip/nix-homebrew";
    };

    # Optional: Declarative tap management
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };

    # Misc Programs

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
    allSupportedSystems = [ "x86_64-linux" "aarch64-darwin" ];
    forAllSystems = nixpkgs.lib.genAttrs allSupportedSystems; 
  in
  {
    # These are the specific host systems that are defined
    nixosConfigurations = {
      weasel = import ./hosts/weasel { inherit inputs; };
    };
    darwinConfigurations = {
      lupus = import ./hosts/lupus { inherit inputs; };
    };

    # These are shells for use when workin in this repository
    devShells = forAllSystems (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        default = pkgs.mkShell {
          buildInputs = [
            pkgs.git
            pkgs.nil # Nix Language Server
          ];
        };
      }
    ); 

    # An attribute set containing templates for new projects
    templates = import ./templates;
  };
}
