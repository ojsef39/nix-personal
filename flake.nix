{
  description = "personal nix configuration";

  inputs = {
    base.url = "github:ojsef39/nix-base";
    # base.url = "/Users/josefhofer/CodeProjects/github.com/ojsef39/nix-base/";
    nixpkgs.follows = "base/nixpkgs";
    darwin.follows = "base/darwin";
    home-manager.follows = "base/home-manager";
    nixcord.follows = "base/nixcord";
  };

  outputs = { base, ... }: let
    vars = {
      user = "josefhofer";
      full_name = "Josef Hofer";
      email = "me@jhofer.de";
      git = {
        ghq = "CodeProjects";
        url = "";
        lazy = {
          # authorColors = ''
          #   "renovate[bot]": "#f4dbd6" # Rosewater
          #   "dependabot[bot]": "#f4dbd6" # Rosewater
          # '';
          };
        nix = "$HOME/${vars.git.ghq}/github.com/ojsef39/nix-personal";
      };
      kitty.project_selector = "~/.config";
      is_vm = false;
    };
    system.darwin.aarch = "aarch64-darwin";
  in {
    darwinConfigurations = {
      "mac" = base.inputs.darwin.lib.darwinSystem {
        system = system.darwin.aarch;
        modules = base.outputs.sharedModules ++ base.outputs.macModules ++ [
          ({ vars, ... }: {
            home-manager.users.${vars.user} = import ./hosts/shared/import.nix;
          })
          ./hosts/darwin/import.nix
          (import ./hosts/darwin/homebrew.nix)
        ];
        specialArgs = { inherit vars system; };
      };
    };

    # Uncomment and adjust the following section if needed
    # nixosConfigurations = {
    #   "linux" = nixpkgs.lib.nixosSystem {
    #     system = system.nixos.aarch;
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
