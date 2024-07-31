{
  pkgs,
  dsl,
  ...
}:

{
  # Toggleterm provides a floating terminal inside the editor for quick access

  plugins = [ pkgs.vimPlugins.toggleterm-nvim ];

  use.toggleterm.setup = dsl.callWith {
    open_mapping = dsl.rawLua "[[<c-\\>]]";
    hide_numbers = true;
    direction = "float";
  };

  lua = ''
    ${builtins.readFile ./toggleterm.lua}
  '';
}
