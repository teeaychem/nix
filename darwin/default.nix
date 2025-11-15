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
      direnv
      fd
      fzf
      gnugrep
      neovim
      nixfmt-rfc-style
      ripgrep
      starship
      tmux
      zoxide
    ];
  };

  programs.home-manager.enable = true;
  programs.starship.enable = true;

  xdg.enable = true;

  imports = [ ../common/git.nix ];

}
