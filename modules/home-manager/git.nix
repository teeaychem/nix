{ pkgs, ... }:
{
  home.packages = with pkgs; [
    git
    delta
    git-filter-repo
    git-lfs
  ];

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "teeaychem";
        email = "bsparkes@alumni.stanford.edu";
      };
      core = {
        pager = "delta";
      };
      delta = {
        navigate = true;
        dark = true;
      };
      init = {
        defaultBranch = "main";
      };
      interactive = {
        diffFilter = "delta --color-only";
      };
      fetch = {
        prune = true;
      };
      filter.lfs = {
        clean = "git-lfs clean -- %f";
        smudge = "git-lfs smudge -- %f";
        process = "git-lfs filter-process";
        required = true;
      };
      rerere = {
        enabled = false;
      };
      status = {
        short = false;
        branch = true;
      };

      alias = {
        l = "log --graph --decorate --pretty=format:'%C(auto)%h %Cblue%ad %Cred%aN %C(auto)%d %n    %s' --date=human";
      };
    };
  };
}
