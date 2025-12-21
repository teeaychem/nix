# nix

## commands

``` shell
home-manager switch --flake .
home-manager switch --flake /etc/nix-darwin/
```

``` shell
sudo nix run nix-darwin -- switch --flake .
sudo nix run nix-darwin -- switch --flake /etc/nix-darwin
```

``` shell
nixfmt **.nix
```

``` shell
home-manager -f /etc/nix-darwin/darwin/home.nix news
```

## getting started

``` shell
nix run github:nix-community/home-manager -- switch --flake .
```

``` shell
sudo nix run nix-darwin/nix-darwin-25.05#darwin-rebuild -- switch
```

https://dev.to/synecdokey/nix-on-macos-2oj3

## hek

- https://github.com/nix-darwin/nix-darwin/issues/871
- https://github.com/nix-community/home-manager/issues/8174
  `rm -r ~/Applications/Home\ Manager\ Apps/` to resolve `error: permission denied when trying to update apps, aborting activation`
