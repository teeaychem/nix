{
  description = "dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nix-darwin,
      emacs-overlay,
      home-manager,
      ...
    }:

    let
      pkg-config = {
        allowUnfree = true;
        allowBroken = true;
        allowInsecure = false;
        allowUnsupportedSystem = false;
      };
      common-overlays = [
        (import emacs-overlay)
      ]
      ++ (
        let
          path = ./overlays;
        in
        with builtins;
        map (n: import (path + ("/" + n))) (
          filter (n: match ".*\\.nix" n != null || pathExists (path + ("/" + n + "/default.nix"))) (
            attrNames (readDir path)
          )
        )
      );
      linux-pkgs = import nixpkgs {
        system = "aarch64-linux";
        config = pkg-config;
        overlays = common-overlays ++ [ ];
      };

      darwin-pkgs = import nixpkgs {
        hostPlatform = "aarch64-darwin";
        system = "aarch64-darwin";
        config = pkg-config;
        overlays = common-overlays ++ [ ];
      };

      darwin-config =
        { config, pkgs, ... }:
        {
          # List packages installed in system profile. To search by name, run:
          # $ nix-env -qaP | grep wget
          environment.systemPackages = [
          ];
          environment.shells = with pkgs; [ bash fish zsh ];

          nix.settings.experimental-features = "nix-command flakes";

          # Set Git commit hash for darwin-version.
          system.configurationRevision = self.rev or self.dirtyRev or null;
          system.stateVersion = 6;
          system.primaryUser = "sparkes";

          nixpkgs.hostPlatform = "aarch64-darwin";
          nix.enable = false;

          system.defaults.dock.autohide = true;
          system.defaults.NSGlobalDomain.AppleFontSmoothing = 0;
          system.defaults.NSGlobalDomain.AppleICUForce24HourTime = true;
          system.defaults.NSGlobalDomain.AppleShowAllExtensions = true;
          system.defaults.NSGlobalDomain.AppleShowAllFiles = true;
          system.defaults.NSGlobalDomain.AppleShowScrollBars = "Always";
          system.defaults.NSGlobalDomain.NSAutomaticCapitalizationEnabled = false;
          system.defaults.NSGlobalDomain.NSAutomaticDashSubstitutionEnabled = false;
          system.defaults.NSGlobalDomain.NSAutomaticInlinePredictionEnabled = false;
          system.defaults.NSGlobalDomain.NSAutomaticPeriodSubstitutionEnabled = false;
          system.defaults.NSGlobalDomain.NSAutomaticQuoteSubstitutionEnabled = false;
          system.defaults.NSGlobalDomain.NSAutomaticSpellingCorrectionEnabled = false;
          system.defaults.NSGlobalDomain.NSAutomaticWindowAnimationsEnabled = false;
          system.defaults.NSGlobalDomain.NSDocumentSaveNewDocumentsToCloud = false;
          system.defaults.NSGlobalDomain.NSNavPanelExpandedStateForSaveMode = true;
          system.defaults.NSGlobalDomain.NSNavPanelExpandedStateForSaveMode2 = true;

          homebrew.enable = true;
          homebrew.taps = [ "d12frosted/emacs-plus" ];
          homebrew.brews = [ "emacs-plus@30" ];
          homebrew.casks = [
            "hammerspoon"
            "feishin"
            "rectangle"
            "syntax-highlight"
            "raycast"
          ];
          homebrew.caskArgs.no_quarantine = true;

          programs.fish.enable = true;
          users.knownUsers = [ config.system.primaryUser ];
          users.users.${config.system.primaryUser} = {
            uid = 501;
            shell = pkgs.fish;
          };
        };

    in
    {

      darwinConfigurations.mbp = nix-darwin.lib.darwinSystem {
        pkgs = darwin-pkgs;
        modules = [ darwin-config ];
      };

      homeConfigurations.sparkes = home-manager.lib.homeManagerConfiguration {
        pkgs = darwin-pkgs;
        modules = [ ./darwin ];
      };

    };
}
