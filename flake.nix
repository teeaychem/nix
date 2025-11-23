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
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    determinate = {
      url = "https://flakehub.com/f/DeterminateSystems/determinate/3";
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
          environment.systemPackages = with pkgs; [
            bat
            coreutils
            delta
            fd
            fzf
            hunspell
            imagemagick
            zellij
            neovim
            nixfmt-rfc-style
            pkgconf
            ripgrep
            starship
            tmux
            typos
            zoxide

            nerd-fonts."m+"
          ];

          environment.shells = with pkgs; [
            bash
            fish
            zsh
          ];

          nix.settings.experimental-features = "nix-command flakes";

          system = {
            configurationRevision = self.rev or self.dirtyRev or null;
            # stateVersion = 6;
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
              "raycast"
              "rectangle"
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

      # nix-darwin module outputs
      darwinModules = {
        # Some base configuration
        base =
          {
            config,
            pkgs,
            lib,
            ...
          }:
          {
            # Required for nix-darwin to work
            system.stateVersion = 1;

            # users.users.${username} = {
            #   name = username;
            #   # See the reference docs for more on user config:
            #   # https://nix-darwin.github.io/nix-darwin/manual/#opt-users.users
            # };

            # Other configuration parameters
            # See here: https://nix-darwin.github.io/nix-darwin/manual
          };

        # Nix configuration
        nixConfig =
          {
            config,
            pkgs,
            lib,
            ...
          }:
          {
            # Let Determinate Nix handle your Nix configuration
            nix.enable = false;

            # Custom Determinate Nix settings written to /etc/nix/nix.custom.conf
            determinate-nix.customSettings = {
              # Enables parallel evaluation (remove this setting or set the value to 1 to disable)
              eval-cores = 0;
              extra-experimental-features = [
                "build-time-fetch-tree" # Enables build-time flake inputs
                "parallel-eval" # Enables parallel evaluation
              ];
              # Other settings
            };
          };

        # Add other module outputs here
      };

      darwinConfigurations."mbp" = nix-darwin.lib.darwinSystem {
        inherit system;
        pkgs = darwin-pkgs;
        modules = [
          inputs.determinate.darwinModules.default
          self.darwinModules.base
          self.darwinModules.nixConfig
          darwin-config
        ];
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
