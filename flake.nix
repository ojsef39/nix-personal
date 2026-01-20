{
  description = "personal nix configuration (test for nix-work compatibility)";

  inputs = {
    base.url = "/Users/josefhofer/CodeProjects/github.com/ojsef39/dotfiles.nix/";
    nixpkgs.follows = "base/nixpkgs";
    darwin.follows = "base/darwin";
    home-manager.follows = "base/home-manager";
    nixcord.follows = "base/nixcord";
    nixkit.follows = "base/nixkit";
    spicetify-nix.follows = "base/spicetify-nix";
    determinate.follows = "base/determinate";
  };

  outputs = {
    base,
    darwin,
    ...
  }: let
    vars = {
      user = {
        name = "josefhofer";
        full_name = "Josef Hofer";
        email = "me@jhofer.de";
        uid = 501;
      };
      git = {
        ghq = "CodeProjects";
        callbacks = {
          "gitlab.die-linke.de" = ''require("gitlinker.hosts").get_gitlab_type_url'';
        };
        url = "";
        lazy = {
          # authorColors = {
          #   "test[bot]" = "#f4dbd6"; # Rosewater
          #   "dependabot[bot]" = "#f4dbd6"; # Rosewater
          # };
        };
        nix = "$HOME/${vars.git.ghq}/github.com/ojsef39/nix-personal";
      };
      kitty.project_selector = "~/.config";
      cache.community = true;
      is_vm = false;
      kubectl-debug.imageName = "kubectl-debug";
    };
  in {
    packages = base.lib.makePackages vars;

    darwinConfigurations = {
      "mac" = darwin.lib.darwinSystem {
        modules =
          [
            {nixpkgs.hostPlatform = "aarch64-darwin";}
          ]
          # Import base modules (SPLIT modules pattern)
          ++ base.outputs.sharedModules
          ++ base.outputs.macModules
          ++ [
            # Personal overrides
            (
              {vars, ...}: {
                home-manager.users.${vars.user.name} = import ./hosts/shared/import-hm.nix;
              }
            )
            ./hosts/shared/import-sys.nix
            ./hosts/darwin/import.nix
            (import ./hosts/darwin/homebrew.nix)
          ];

        specialArgs = {
          inherit vars;
          baseLib = base.lib;
        };
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
