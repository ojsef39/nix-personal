{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    wireshark
    ## media stuff
    yt-dlp
    moonlight-qt
  ];
}
