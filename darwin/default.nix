{ pkgs, ... }:
{

  home = {
    stateVersion = "25.05";
    username = "sparkes";
    homeDirectory = "/Users/sparkes";

    file.".config" = {
      source = ./config;
      recursive = true;
    };

    packages = with pkgs; [
      cmake
      # emacs-derived
      emacs-lsp-booster
      gnugrep

      cvc5
      z3

      gersemi
      ruff
      rust-analyzer
      taplo
    ];
  };

  programs = {
    direnv.enable = true;
    fish.enable = true;
    home-manager.enable = true;
    starship = {
      enable = true;
      enableFishIntegration = true;
    };
  };

  xdg.enable = true;

  imports = [
    ../common/git.nix
    ../common/tmux.nix
  ];

}
