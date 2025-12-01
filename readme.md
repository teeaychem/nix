# nix

## commands

home-manager switch --flake .

sudo nix run nix-darwin -- switch --flake .

nixfmt **.nix

## getting started

nix run github:nix-community/home-manager -- switch --flake .

sudo nix run nix-darwin/nix-darwin-25.05#darwin-rebuild -- switch

https://dev.to/synecdokey/nix-on-macos-2oj3

## hek

- https://github.com/nix-darwin/nix-darwin/issues/871
- https://github.com/nix-community/home-manager/issues/8174
  `rm -r ~/Applications/Home\ Manager\ Apps/` to resolve `error: permission denied when trying to update apps, aborting activation`
