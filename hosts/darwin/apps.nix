{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    fluxcd
  ];
}
