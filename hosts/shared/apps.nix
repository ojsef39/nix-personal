{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # wireshark # broken
    ## media stuff
    yt-dlp
    moonlight-qt
  ];
}
