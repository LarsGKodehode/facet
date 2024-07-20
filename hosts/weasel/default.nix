# The Weasel
# System configuration for a WSL instance

{
  inputs,
  globals,
}:

inputs.nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  modules = [
    inputs.nixos-wsl.nixosModules.default
    {
      system.stateVersion = "24.05";
      wsl.enable = true;
      wsl.defaultUser = globals.user;
    }
  ];
}
