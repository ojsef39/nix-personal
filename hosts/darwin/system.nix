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
          "/System/Applications/Mail.app"
          "/System/Applications/Calendar.app"
          "/Applications/WhatsApp.app"
          "/System/Applications/Messages.app"
          "${pkgs.discord}/Applications/Discord.app"
          "${pkgs.obsidian}/Applications/Obsidian.app"
          "/Applications/Goodnotes.app"
          "/Applications/Reeder.app"
          "/Applications/Linear.app"
          "/Applications/kitty.app"
          "/Applications/Lens.app"
          "${pkgs.utm}/Applications/UTM.app"
          "/Applications/Shadow PC Beta.app"
          "/System//Applications/Music.app"
          "/System//Applications/System Settings.app"
          "/Applications/Yubico Authenticator.app"
          "/Applications/Poe.app"
          "/System/Applications/iPhone Mirroring.app"
        ];
      };
      # Unlock the Dock so this and base config can edit it
      CustomUserPreferences = {
        "com.apple.dock" = {
          "contents-immutable" = 0;
          "size-immutable" = 0;
          "position-immutable" = 0;
        };
      };
    };
  };
}

