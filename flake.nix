{
  description = "dotfiles";

  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-25.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      ...
    }@inputs:

    let
      inherit (self) outputs;

      pkg-config = {
        allowUnfree = true;
        allowBroken = true;
        allowInsecure = false;
        allowUnsupportedSystem = false;
      };

      common-overlays = [
        (import inputs.emacs-overlay)
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
          # $ nix-env -qaP
          environment.systemPackages = with pkgs; [
            bat
            coreutils
            fd
            fzf
            hunspell
            imagemagick
            neovim
            nixfmt-rfc-style
            pkgconf
            ripgrep
            starship
            tmux
            typos
            zoxide
          ];

          environment.shells = with pkgs; [
            bash
            fish
            zsh
          ];

          nix = {
            enable = false;
            settings.experimental-features = "nix-command flakes";
          };

          system = {
            configurationRevision = self.rev or self.dirtyRev or null;
            stateVersion = 6;
            primaryUser = "sparkes";
          };

          nixpkgs.hostPlatform = "aarch64-darwin";

          system.defaults = {
            dock.autohide = true;
            NSGlobalDomain = {
              AppleFontSmoothing = 0;
              AppleICUForce24HourTime = true;
              AppleShowAllExtensions = true;
              AppleShowAllFiles = true;
              AppleShowScrollBars = "Always";
              NSAutomaticCapitalizationEnabled = false;
              NSAutomaticDashSubstitutionEnabled = false;
              NSAutomaticInlinePredictionEnabled = false;
              NSAutomaticPeriodSubstitutionEnabled = false;
              NSAutomaticQuoteSubstitutionEnabled = false;
              NSAutomaticSpellingCorrectionEnabled = false;
              NSAutomaticWindowAnimationsEnabled = false;
              NSDocumentSaveNewDocumentsToCloud = false;
              NSNavPanelExpandedStateForSaveMode = true;
              NSNavPanelExpandedStateForSaveMode2 = true;
            };
          };

          homebrew = {
            enable = true;
            taps = [ "d12frosted/emacs-plus" ];
            brews = [ "emacs-plus@30" ];
            casks = [
              "feishin"
              "raycast"
              "rectangle"
              "syntax-highlight"
              "hammerspoon"
            ];
            caskArgs.no_quarantine = true;
          };

          programs.fish.enable = true;

          users = {
            knownUsers = [ config.system.primaryUser ];
            users.${config.system.primaryUser} = {
              uid = 501;
              shell = pkgs.fish;
            };
          };
        };

    in

    {

      darwinConfigurations.mbp = inputs.nix-darwin.lib.darwinSystem {
        pkgs = darwin-pkgs;
        modules = [ darwin-config ];
      };

      homeConfigurations = {
        sparkes = inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = darwin-pkgs;
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [ ./darwin ];
        };
      };

    };
}
