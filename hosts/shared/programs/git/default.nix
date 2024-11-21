{ lib, vars, ...}: {
  programs.git = {
    userName = "${vars.full_name}";
    userEmail = "${vars.email}";

    extraConfig = {
      # GHQ configurations
      "ghq \"https://github.com/\"" = {
        vcs = "git";
        root = "~/${vars.git.ghq}";
      };
      "ghq \"https://gitlab.com/\"" = {
        vcs = "git";
        root = "~/${vars.git.ghq}";
      };
    };
  };
}

