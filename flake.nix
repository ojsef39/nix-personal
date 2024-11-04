{
  description = "personal nix configuration";

  inputs = {
    # base.url = "github:ojsef39/nix-base/dev";
    base.url = "/Users/josefhofer/CodeProjects/github.com/ojsef39/nix-base/";
  };

  outputs = { self, base, ... }: let
    vars = {
      user = "josefhofer";
      email = "me@jhofer.de";
    };
  in {
    darwinConfigurations = {
      "mac" = base.inputs.darwin.lib.darwinSystem {
        system = "aarch64-darwin";  # or "x86_64-darwin"
        modules = base.outputs.sharedModules ++ base.outputs.macModules ++ [
          ({ vars, ... }: {
            home-manager.users.${vars.user} = import ./hosts/shared/import.nix;
          })
        ];
        specialArgs = { inherit vars; };
      };
    };

    # Uncomment and adjust the following section if needed
    # nixosConfigurations = {
    #   "linux" = nixpkgs.lib.nixosSystem {
    #     system = "x86_64-linux";
    #     modules = [
    #       base.baseModules
    #       {
    #         programs.bash = {
    #           enable = true;
    #           shellAliases = {
    #             open = "xdg-open";
    #           };
    #         };
    #       }
    #     ];
    #   };
    # };
  };
}
