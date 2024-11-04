{ pkgs, lib, ... }:
{
  programs.neovim = {
    extraPackages = with pkgs; [
     fzf
    ];
  };
}
