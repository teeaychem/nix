{ pkgs, ... }:
{
  imports = [ ./git.nix ];
  home.packages = with pkgs; [
    bat
    cmake
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
}
