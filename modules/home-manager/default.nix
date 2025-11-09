{pkgs, ...}: {
  imports = [./git.nix];
  home.packages = with pkgs; [
    bat
    cmake
    fd
    fzf
    gnugrep
    ripgrep
    starship
    tmux
    zoxide
  ];
}
