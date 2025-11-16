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
      bat
      cmake
      cvc5
      # emacs-derived
      emacs-lsp-booster
      fd
      fzf
      gnugrep
      neovim
      nixfmt-rfc-style
      ripgrep
      starship
      tmux
      zoxide
      z3
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
