{ pkgs, inputs, lib, ... }:

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
          "/Applications/Mail.app"
          "/Applications/Calendar.app"
          "/Applications/WhatsApp.app"
          "/Applications/Messages.app"
          "${pkgs.discord}/Applications/Discord.app"
          "${pkgs.obsidian}/Applications/Obsidian.app"
          "/Applications/Goodnotes.app"
          "/Applications/Reeder.app"
          "/Applications/Linear.app"
          "/Applications/kitty.app"
          "/Applications/Lens.app"
          "${pkgs.utm}/Applications/UTM.app"
          "/Applications/Shadow PC Beta.app"
          "/Applications/Music.app"
          "/Applications/System Settings.app"
          "/Applications/Yubico Authenticator.app"
          "/Applications/Poe.app"
          "/System/Applications/iPhone Mirroring.app"
        ];
      };
    };
  };
}

