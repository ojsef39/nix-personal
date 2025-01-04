{ pkgs, lib, vars, ... }: {

  programs.zsh = {
    initExtra = ''
      # Source MEGA completion
      # source /Applications/MEGAcmd.app/Contents/MacOS/megacmd_completion.sh

      # Source additional scripts
      if [ -d $HOME/.zsh_scripts ]; then
        for file in $HOME/.zsh_scripts_local/*.zsh; do
          source $file
        done
      fi

    '';

    # Aliases
    shellAliases = {
      talos = "talosctl";
    };
  };

  home = {
    file = {
      ".zsh_scripts_local/" = {
        recursive = true;
        source = ./zsh_scripts;
      };
    };
  };

}
