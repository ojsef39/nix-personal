{ lib, vars, ...}: {
  programs.git = {
    userName = "${vars.full_name}";
    userEmail = "${vars.email}";
    "user.signingkey" = "${vars.signing_key1}";
    "commit.gpgSign" = true;

    extraConfig = {
      # GHQ configurations
      "ghq \"https://github.com/\"" = {
        vcs = "git";
        root = "~/Code/";
      };
      "ghq \"https://gitlab.com/\"" = {
        vcs = "git";
        root = "~/Code/";
      };
    };
  };
}

