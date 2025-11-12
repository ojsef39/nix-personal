{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    ## media stuff
    yt-dlp
    moonlight-qt
  ];
}
