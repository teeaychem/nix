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

  programs.direnv.enable = true;
  programs.fish.enable = true;
  programs.home-manager.enable = true;
  programs.starship.enable = true;

  xdg.enable = true;

  imports = [ ../common/git.nix ];

}
