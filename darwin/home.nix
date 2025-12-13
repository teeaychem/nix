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
      source = ../dot-config/og;
      recursive = true;
    };

    packages = with pkgs; [
      cmake
      emacs-derived-plus
      gnugrep
      lazygit
      qemu

      cvc5
      z3

      python3

      # llvmPackages_21.clang-tools
      comrak # GF(Markdown)
      gersemi
      luajitPackages.luarocks
      nil
      prettier
      pyrefly
      ruff
      # rust-analyzer
      taplo

      feishin
      keka
      keepassxc
    ];
  };

  programs = {
    fish.enable = true;
    home-manager.enable = true;
    starship = {
      enable = true;
      enableFishIntegration = true;
    };

  };

  xdg.enable = true;

  imports = [
    ../dot-config/nix/direnv.nix
    ../dot-config/nix/git.nix
    ../dot-config/nix/tmux.nix
  ];

}
