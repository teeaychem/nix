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
      bitwise
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
    ];
  };

  fonts.packages = [
    pkgs.nerd-fonts."m+"
  ];

  nix.settings.experimental-features = "nix-command flakes";

  system = {
    configurationRevision = null;
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
    taps = [
      "d12frosted/emacs-plus"
    ];
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
}
