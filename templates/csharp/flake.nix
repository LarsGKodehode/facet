# Documentation for developing C# and .NET application with Nix
# https://github.com/NixOS/nixpkgs/blob/master/doc/languages-frameworks/dotnet.section.md

{
  description = "A Nix-flake-based C# development environment";

  inputs.nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1.*.tar.gz";

  outputs =
    { self, nixpkgs }:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forEachSupportedSystem =
        f: nixpkgs.lib.genAttrs supportedSystems (system: f { pkgs = import nixpkgs { inherit system; }; });
    in
    {
      devShells = forEachSupportedSystem (
        { pkgs }:
        {
          default = pkgs.mkShell {
            packages = [
              pkgs.dotnetCorePackages.sdk_8_0 # Runtime and 
              pkgs.omnisharp-roslyn # Language Server for C#
            ];

            # Environment Variables
            DOTNET_ROOT = builtins.toString pkgs.dotnetCorePackages.sdk_8_0;
          };
        }
      );
    };
}
