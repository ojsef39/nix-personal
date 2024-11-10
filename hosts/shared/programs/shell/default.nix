{ pkgs, lib, vars, ... }: {

  programs.zsh = {
    initExtra = ''
      # Source MEGA completion
      # source /Applications/MEGAcmd.app/Contents/MacOS/megacmd_completion.sh
    '';

    # Aliases
    shellAliases = {};
  };
}
