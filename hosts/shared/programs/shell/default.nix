{ pkgs, lib, vars, ... }: {

  programs.zsh = {
    # Environment variables
    sessionVariables = {
      PATH = lib.concatStringsSep ":" [
        "$PATH"
      ];
    };

    initExtra = ''
      # Source MEGA completion
      # source /Applications/MEGAcmd.app/Contents/MacOS/megacmd_completion.sh
    '';

    # Aliases
    shellAliases = {
      please = "sudo";
      ls = "eza --icons --git --header";
      x = "exit";
    };
  };
}
