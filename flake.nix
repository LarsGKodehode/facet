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

    # Neovim sources
    # Convert Nix to Neovim config
    nix2vim = {
      url = "github:gytis-ivaskevicius/nix2vim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Neovim plugins
    base16-nvim-src = {
      url = "github:RRethy/base16-nvim";
      flake = false;
    };
    nvim-lspconfig-src = {
      # https://github.com/neovim/nvim-lspconfig/tags
      url = "github:neovim/nvim-lspconfig/v0.1.8";
      flake = false;
    };
    cmp-nvim-lsp-src = {
      url = "github:hrsh7th/cmp-nvim-lsp";
      flake = false;
    };
    baleia-nvim-src = {
      # https://github.com/m00qek/baleia.nvim/tags
      url = "github:m00qek/baleia.nvim";
      flake = false;
    };
    nvim-treesitter-src = {
      # https://github.com/nvim-treesitter/nvim-treesitter/tags
      url = "github:nvim-treesitter/nvim-treesitter/master";
      flake = false;
    };
    telescope-nvim-src = {
      # https://github.com/nvim-telescope/telescope.nvim/releases
      url = "github:nvim-telescope/telescope.nvim/0.1.8";
      flake = false;
    };
    telescope-project-nvim-src = {
      url = "github:nvim-telescope/telescope-project.nvim";
      flake = false;
    };
    toggleterm-nvim-src = {
      # https://github.com/akinsho/toggleterm.nvim/tags
      url = "github:akinsho/toggleterm.nvim/v2.11.0";
      flake = false;
    };
    bufferline-nvim-src = {
      # https://github.com/akinsho/bufferline.nvim/releases
      url = "github:akinsho/bufferline.nvim/v4.6.1";
      flake = false;
    };
    nvim-tree-lua-src = {
      url = "github:kyazdani42/nvim-tree.lua";
      flake = false;
    };
    hmts-nvim-src = {
      url = "github:calops/hmts.nvim";
      flake = false;
    };
    fidget-nvim-src = {
      # https://github.com/j-hui/fidget.nvim/tags
      url = "github:j-hui/fidget.nvim/v1.4.5";
      flake = false;
    };
    nvim-lint-src = {
      url = "github:mfussenegger/nvim-lint";
      flake = false;
    };
    markview-nvim-src = {
      url = "github:OXY2DEV/markview.nvim";
      flake = false;
    };

    # Tree-Sitter Grammars
    tree-sitter-bash = {
      url = "github:tree-sitter/tree-sitter-bash/master";
      flake = false;
    };
    tree-sitter-python = {
      url = "github:tree-sitter/tree-sitter-python/master";
      flake = false;
    };
    tree-sitter-lua = {
      url = "github:MunifTanjim/tree-sitter-lua/main";
      flake = false;
    };
  };

  outputs = { nixpkgs, ... }@inputs:
  let
    # Common Overlays to always apply
    overlays = [
      inputs.nix2vim.overlay
      (import ./overlays/neovim-plugins.nix inputs)
    ];

    # Helper function for generating an attribute set
    allSupportedSystems = [ "x86_64-linux" ];
    forAllSystems = nixpkgs.lib.genAttrs allSupportedSystems;
  in
  {
    # These are the specific host systems that are defined
    nixosConfigurations = {
      weasel = import ./hosts/weasel { inherit inputs overlays; };
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
