{ pkgs, lib, ... }:
{
  programs.neovim = {
    enable = false;
    viAlias = false;
    vimAlias = false;

    extraPackages = with pkgs; [
     fzf
    ];
  };
}
