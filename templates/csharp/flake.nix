# Documentation for developing C# and .NET application with Nix
# https://github.com/NixOS/nixpkgs/blob/master/doc/languages-frameworks/dotnet.section.md

{
  description = "A Nix-flake-based C# development environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      allSupportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forEachSupportedSystems = nixpkgs.lib.genAttrs allSupportedSystems;
    in
    {
      devShells = forEachSupportedSystems (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
        in
        {
          default = pkgs.mkShell {
            packages = [
              # Cloud tools
              pkgs.azure-cli
              pkgs.terraform

              # C# and ASP .NET Core
              pkgs.dotnetCorePackages.sdk_8_0
              pkgs.omnisharp-roslyn
            ];

            # Environment Variables
            # Expose the exact path to the Dotnet binaries
            DOTNET_ROOT = builtins.toString pkgs.dotnetCorePackages.sdk_8_0;
            DOTNET_BIN = "${pkgs.dotnetCorePackages.sdk_8_0}/bin/dotnet";
          };
        }
      );
    };
}
