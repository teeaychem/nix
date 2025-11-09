{config, ...}: {
  nixpkgs.config.allowUnfreePredicate = pkg: true;
  home = {
    stateVersion = "25.05";
    username = "sparkes";
    homeDirectory = "/Users/sparkes";

    file.".config" = {
      source = ./config;
      recursive = true;
    };
  };

  xdg.enable = true;

  programs.home-manager.enable = true;
  programs.starship.enable = true;
  imports = [./modules/home-manager];
}
