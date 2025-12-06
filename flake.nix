{
  description = "dotfiles";

  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-25.11";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
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
      nix-darwin,
      home-manager,
      ...
    }@inputs:

    let
      inherit (self) outputs;

      system = "aarch64-darwin";

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
          nix.enable = false;

          environment = {
            shells = with pkgs; [
              bash
              fish
              zsh
            ];

            systemPackages = with pkgs; [
              bat
              coreutils
              delta
              fd
              fzf
              hunspell
              imagemagick
              neovim
              nix-your-shell
              nixfmt-rfc-style
              pkg-configUpstream # ?pkg-config fails
              ripgrep
              starship
              tmux
              typos
              zellij
              zoxide

              tree-sitter
              tree-sitter-grammars.tree-sitter-bash
              tree-sitter-grammars.tree-sitter-c
              tree-sitter-grammars.tree-sitter-cpp
              tree-sitter-grammars.tree-sitter-elisp
              tree-sitter-grammars.tree-sitter-fish
              tree-sitter-grammars.tree-sitter-haskell
              tree-sitter-grammars.tree-sitter-javascript
              tree-sitter-grammars.tree-sitter-json
              tree-sitter-grammars.tree-sitter-latex
              tree-sitter-grammars.tree-sitter-lua
              tree-sitter-grammars.tree-sitter-nix
              tree-sitter-grammars.tree-sitter-ocaml
              tree-sitter-grammars.tree-sitter-python
              tree-sitter-grammars.tree-sitter-rust
              tree-sitter-grammars.tree-sitter-scheme
              tree-sitter-grammars.tree-sitter-toml
              tree-sitter-grammars.tree-sitter-vim

            ];
          };

          fonts.packages = [
            pkgs.nerd-fonts."m+"
          ];

          nix.settings.experimental-features = "nix-command flakes";

          system = {
            configurationRevision = self.rev or self.dirtyRev or null;
            stateVersion = 6;
            primaryUser = "sparkes";

            defaults = {
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

            keyboard = {
              enableKeyMapping = true;
              remapCapsLockToControl = true;
            };
          };

          nixpkgs.hostPlatform = "aarch64-darwin";

          homebrew = {
            enable = true;
            onActivation.autoUpdate = true;
            # taps = [ "d12frosted/emacs-plus" ];
            brews = [
              # "emacs-plus@30"
            ];
            casks = [
              "doll"
              "hammerspoon"
              "raycast"
              "rectangle"
              "skim"
              "xld"
              "vlc"
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

      darwinConfigurations."mbp" = nix-darwin.lib.darwinSystem {
        inherit system;
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
