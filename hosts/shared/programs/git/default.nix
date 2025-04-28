{ vars, ...}: {
  programs.git = {
    userName = "${vars.user.full_name}";
    userEmail = "${vars.user.email}";
    signing = {
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAnnOOtnSeqQ3+XjO2jaC5k0pk5BIZVB4YI3KukF4o83";
      signByDefault = true;
    };
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

      gpg = {
        format = "ssh";
      };
      "gpg \"ssh\"" = {
        program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
      };
    };
  };
}
