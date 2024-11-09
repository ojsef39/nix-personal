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
    # activationScripts are executed every time you boot the system or run `nixos-rebuild` / `darwin-rebuild`.
    activationScripts.postUserActivation.text = ''
      # activateSettings -u will reload the settings from the database and apply them to the current session,
      # so we do not need to logout and login again to make the changes take effect.
      /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
    '';

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

