{ pkgs, config, vars, ... }:

###################################################################################
#
#  macOS's System configuration
#
#  All the configuration options are documented here:
#    https://daiderd.com/nix-darwin/manual/index.html#sec-options
#
#  See your own values with for example: `defaults read com.apple.dock tilesize`
#
###################################################################################

{
  system = {
    defaults = {
      dock = {
        # tilesize = 62; # Just so i know the before value
        # largesize = 64; # Just so i know the before value
        persistent-apps = [
          "/Applications/Arc.app"
          "/System/Applications/Mail.app"
          "/System/Applications/Calendar.app"
          "/Applications/WhatsApp.app"
          "/System/Applications/Messages.app"
          "${config.home-manager.users.${vars.user.name}.programs.nixcord.vesktop.package}/Applications/Vesktop.app"
          "${pkgs.obsidian}/Applications/Obsidian.app"
          "/Applications/Things3.app"
          "/Applications/Linear.app"
          "/Applications/kitty.app"
          "${pkgs.utm}/Applications/UTM.app"
          "/Applications/Shadow PC Beta.app"
          "/System//Applications/Music.app"
          "/System//Applications/System Settings.app"
          "/Applications/Yubico Authenticator.app"
          "/Applications/Claude.app"
          "/System/Applications/iPhone Mirroring.app"
        ];
      };
    };
  };
}

