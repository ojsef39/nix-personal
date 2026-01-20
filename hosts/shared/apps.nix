{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # wireshark # broken
    ## media stuff
    yt-dlp
    moonlight-qt
    # packages from base
    kubectl-debug
  ];
}
