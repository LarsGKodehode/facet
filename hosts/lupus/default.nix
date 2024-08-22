# Lups
# System configuration for my Macbook Air

{
  inputs,
  ...
}:

let
  configuration = { inputs, globals, overlays, ... }: {
    hostName = "lupus";

    # List packages installed in system profile. To search by name, run:
    # $ nix-env -qaP | grep wget
    environment.systemPackages =
    [
      inputs.nixpkgs.git
      inputs.nixpkgs.vim
    ];

    # Auto upgrade nix package and the daemon service.
    services.nix-daemon.enable = true;
    # nix.package = pkgs.nix;

    # Necessary for using flakes on this system.
    nix.settings.experimental-features = "nix-command flakes";

    # Create /etc/zshrc that loads the nix-darwin environment.
    programs.zsh.enable = true;  # default shell on catalina
    # programs.fish.enable = true;

    # Set Git commit hash for darwin-version.
    #system.configurationRevision = self.rev or self.dirtyRev or null;

    # Used for backwards compatibility, please read the changelog before changing.
    # $ darwin-rebuild changelog
    system.stateVersion = 4;

    # The platform the configuration will be used on.
    nixpkgs.hostPlatform = "aarch64-darwin";
  };
in
inputs.darwin.lib.darwinSystem {
  system = "aarch64-darwin";
  specialArgs = { };
  modules = [
    {
      networking.hostName = "${configuration.hostName}";
      theme = {
        colors = (import ../../modules/colorscheme/gruvbox).dark;
        dark = true;
      };

      darwinConfigurations.${configuration.hostName} = inputs.darwin.lib.darwinSystem {
        modules = [ configuration ];
      };

      darwinPackages = inputs.darwin.darwinConfigurations.${configuration.hostName}.pkgs;
    }
  ];
}

