{
  inputs,
  outputs,
  pkgs,
  ...
}:
{

  home = {
    stateVersion = "25.11";
    username = "sparkes";
    homeDirectory = "/Users/sparkes";

    file.".config" = {
      source = ./config;
      recursive = true;
    };

    packages = with pkgs; [
      cmake
      emacs-derived-plus
      gnugrep
      qemu

      cvc5
      z3

      python3

      # llvmPackages_21.clang-tools
      comrak # GF(Markdown)
      gersemi
      nil
      ruff
      # rust-analyzer
      taplo

      feishin
      keka
      keepassxc
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
