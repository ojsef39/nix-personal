{
  description = "personal nix configuration";

  inputs = {
    base.url = "github:ojsef39/nix-base/dev";
  };

  outputs = { self, base }: {
    let
      vars = {
        user = "josefhofer";
        email = "me@jhofer.de"
      };

    in { 
      darwinConfigurations = {
        # Simplified to just "mac"
        "mac" = base.inputs.darwin.lib.darwinSystem {
          system = "aarch64-darwin";  # or x86_64-darwin
          modules = base.outputs.sharedModules ++ base.outputs.macModules ++ [
            # Mac-specific shell customizations
            {
              programs.zsh = {
                enable = true;
              };
            }
          ];
        };

      };

      # nixosConfigurations = {
      #   "linux" = nixpkgs.lib.nixosSystem {
      #     system = "x86_64-linux";
      #     modules = [
      #       base.baseModules
      #       # Linux-specific shell customizations
      #       {
      #         programs.bash = {
      #           enable = true;
      #           # Add Linux-specific aliases or settings
      #           shellAliases = {
      #             # Linux-specific aliases
      #             open = "xdg-open";
      #             # ... more Linux-specific aliases
      #           };
      #         };
      #       }
      #     ];
      #   };
      # };
    }
  };
}
