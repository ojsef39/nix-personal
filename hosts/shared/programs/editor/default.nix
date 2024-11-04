{ pkgs, lib, ... }:
{
  programs.neovim = {
    viAlias = false;
    vimAlias = false;

    extraPackages = with pkgs; [
     fzf
    ];
  };
}
