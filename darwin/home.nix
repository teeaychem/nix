{
  inputs,
  outputs,
  pkgs,
  pkgs-unstable,
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

    packages = [
      pkgs.cmake
      pkgs.emacs-derived-plus
      pkgs.gnugrep
      pkgs.lazygit
      pkgs.qemu

      pkgs.cvc5
      pkgs.z3

      pkgs.python3

      # llvmPackages_21.clang-tools
      pkgs.comrak # GF(Markdown)
      pkgs.gersemi
      pkgs.luajitPackages.luarocks
      pkgs.nil
      pkgs.prettier
      pkgs.ruff
      # pkgs.rust-analyzer
      pkgs.taplo
      pkgs.universal-ctags

      pkgs.feishin
      pkgs.keka
      pkgs.keepassxc
      pkgs.xld

      pkgs-unstable.ty
    ];
  };

  programs = {
    fish.enable = true;

    home-manager.enable = true;

    starship = {
      enable = true;
      enableFishIntegration = true;
    };

    gpg = {
      enable = true;
    };

  };

  services.gpg-agent = {
    enable = true;
    enableFishIntegration = true;
  };

  xdg.enable = true;

  imports = [
    ../dot-config/nix/direnv.nix
    ../dot-config/nix/git.nix
    ../dot-config/nix/tmux.nix
  ];

}
