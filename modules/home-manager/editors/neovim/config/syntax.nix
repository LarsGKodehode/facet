{
  pkgs,
  ...
}:

{

  plugins = [
    (pkgs.vimPlugins.nvim-treesitter.withPlugins (
      _plugins: with pkgs.tree-sitter-grammars; [
        tree-sitter-bash
        tree-sitter-c
        tree-sitter-fish
        tree-sitter-json
        tree-sitter-lua
        tree-sitter-markdown
        tree-sitter-markdown-inline
        tree-sitter-nix
        tree-sitter-python
        tree-sitter-toml
        tree-sitter-yaml
      ]
    ))
    pkgs.vimPlugins.vim-matchup # Better % jumping in languages
    pkgs.vimPlugins.playground # Tree-sitter experimenting
    pkgs.vimPlugins.nginx-vim
    # pkgs.vimPlugins.hmts-nvim # Tree-sitter injections for home-manager
  ];

  setup."nvim-treesitter.configs" = {
    highlight = {
      enable = true;
    };
    indent = {
      enable = true;
    };
    matchup = {
      enable = true;
    }; # Uses vim-matchup

    textobjects = {
      select = {
        enable = true;
        lookahead = true; # Jump forward automatically

        keymaps = {
          "['af']" = "@function.outer";
          "['if']" = "@function.inner";
          "['ac']" = "@class.outer";
          "['ic']" = "@class.inner";
          "['al']" = "@loop.outer";
          "['il']" = "@loop.inner";
          "['aa']" = "@call.outer";
          "['ia']" = "@call.inner";
          "['ar']" = "@parameter.outer";
          "['ir']" = "@parameter.inner";
          "['aC']" = "@comment.outer";
          "['iC']" = "@comment.outer";
          "['a/']" = "@comment.outer";
          "['i/']" = "@comment.outer";
          "['a;']" = "@statement.outer";
          "['i;']" = "@statement.outer";
        };
      };
    };
  };
}
