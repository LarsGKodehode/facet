# Copied from:
# https://github.com/nmasur/dotfiles/blob/de4c8c32ef01c9bc93fbec08a5403ca281bf6036/overlays/neovim-plugins.nix
# and https://github.com/DieracDelta/vimconfig/blob/4c5e47df4432ad33072f1dcb4d746fcca628517a/plugins.nix

inputs: final: prev:

let
  # Use nixpkgs vimPlugin but with source directly from plugin author
  withSrc =
    pkg: src:
    pkg.overrideAttrs (_: {
      inherit src;
    });

  # Package plugin - for plugins not found in nixpkgs at all
  plugin =
    pname: src:
    prev.vimUtils.buildVimPlugin {
      inherit pname src;
      version = "master";
    };
in
{
  vimPlugins = prev.vimPlugins // {
    nvim-lspconfig = withSrc prev.vimPlugins.nvim-lspconfig inputs.nvim-lspconfig-src;
    cmp-nvim-lsp = withSrc prev.vimPlugins.cmp-nvim-lsp inputs.cmp-nvim-lsp-src;
    nvim-treesitter = withSrc prev.vimPlugins.nvim-treesitter inputs.nvim-treesitter-src;
    telescope-nvim = withSrc prev.vimPlugins.telescope-nvim inputs.telescope-nvim-src;
    telescope-project-nvim = withSrc prev.vimPlugins.telescope-project-nvim inputs.telescope-project-nvim-src;
    toggleterm-nvim = withSrc prev.vimPlugins.toggleterm-nvim inputs.toggleterm-nvim-src;
    bufferline-nvim = withSrc prev.vimPlugins.bufferline-nvim inputs.bufferline-nvim-src;
    nvim-tree-lua = withSrc prev.vimPlugins.nvim-tree-lua inputs.nvim-tree-lua-src;
    fidget-nvim = withSrc prev.vimPlugins.fidget-nvim inputs.fidget-nvim-src;
    nvim-lint = withSrc prev.vimPlugins.nvim-lint inputs.nvim-lint-src;

    # Packaging plugins entirely with Nix
    base16-nvim = plugin "base16-nvim" inputs.base16-nvim-src;
    baleia-nvim = plugin "baleia-nvim" inputs.baleia-nvim-src;
    hmts-nvim = plugin "hmts-nvim" inputs.hmts-nvim-src;
    markview-nvim = plugin "markview-nvim" inputs.markview-nvim-src;
  };
}