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

      renovate_summary() {
        pipx install tabulate
        source ~/.local/pipx/venvs/tabulate/bin/activate
        python3 /Users/${vars.user}/${vars.git.ghq}/github.com/ojsef39/renovate-dependency-summary-no-config/renovate-summary.py
        deactivate
      }
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
