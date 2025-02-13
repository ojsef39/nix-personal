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

      # Export the talosconfig
      export TALOSCONFIG=/tmp/talosconfig

      export PATH=$PATH:/Users/${vars.user}/${vars.git.ghq}/github.com/ojsef39/renovate-dependency-summary-no-config
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
