{ pkgs, ... }:
{
  # Keep this here even if empty for yuki compatibility
  environment.systemPackages = with pkgs; [
    #pkg1
  ];
}
