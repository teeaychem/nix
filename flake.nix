{
  description = "dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      nixpkgs,
      home-manager,
      ...
    }:

    let
      pkg-config = {
        allowUnfree = true;
        allowBroken = true;
        allowInsecure = false;
        allowUnsupportedSystem = false;
      };
      common-overlays = [ ];
      linux-pkgs = import nixpkgs {
        system = "aarch64-linux";
        config = pkg-config;
        overlays = common-overlays ++ [ ];
      };
      darwin-pkgs = import nixpkgs {
        system = "aarch64-darwin";
        config = pkg-config;
        overlays = common-overlays;
      };
    in
    {
      homeConfigurations.sparkes = home-manager.lib.homeManagerConfiguration {
        pkgs = darwin-pkgs;
        modules = [ ./darwin ];
      };

    };
}
