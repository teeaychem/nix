# https://wiki.nixos.org/wiki/Emacs

# https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/editors/emacs/default.nix
# - https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/editors/emacs/make-emacs.nix

# https://github.com/nix-community/emacs-overlay/blob/master/overlays/emacs.nix

# https://github.com/d12frosted/homebrew-emacs-plus

self: super: rec {
  emacs-derived = super.emacs-unstable.override {
  };
  emacs-derivedBase =
    if super.stdenv.isDarwin then
      emacs-derived.overrideAttrs (old: {
        patches = [
          (super.fetchpatch {
            url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/refs/heads/master/patches/emacs-28/fix-window-role.patch";
          })
          (super.fetchpatch {
            url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/master/patches/emacs-30/round-undecorated-frame.patch";
          })
          (super.fetchpatch {
            url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/refs/heads/master/patches/emacs-30/system-appearance.patch";
          })
        ];
      })
    else
      emacs-derived;
}
