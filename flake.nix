{
  description = "personal nix configuration";

  inputs = {
    base.url = "github:ojsef39/nix-base/dev";
  };

  outputs = { self, nixpkgs, darwin, home-manager, base }: {
    darwinConfigurations = {
      # Simplified to just "mac"
      "mac" = darwin.lib.darwinSystem {
        system = "aarch64-darwin";  # or x86_64-darwin
        modules = [
          base.sharedModuls
          base.macModules
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
  };
}
