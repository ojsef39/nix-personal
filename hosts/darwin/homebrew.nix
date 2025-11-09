{
  vars,
  lib,
  ...
}: {
  # Homebrew for macOS-specific and unavailable packages
  homebrew = {
    taps = [];

    # Mac App Store apps
    masApps = lib.mkIf (!vars.is_vm) {
      "CrystalFetch" = 6454431289;
      "Parcel" = 639968404;
      "Keynote" = 409183694;
      "Final Cut Pro" = 424389933;
      "Usage" = 1561788435;
      "Motion" = 434290957;
      "The Unarchiver" = 425424353;
      "TestFlight" = 899247664;
      "Ground News" = 1324203419;
      "Book Tracker" = 1496543317;
      "Pages" = 409201541;
      "Reeder" = 1529448980;
      "Goodnotes" = 1444383602;
      "Numbers" = 409203825;
      "Pixelmator Pro" = 1289583905;
      "Tailscale" = 1475387142;
      # "waifu2x" = 1286485858;
    };

    # Homebrew formulae (CLI tools)
    brews = [
      "Graphviz"
      "expect"
      "iperf3"
      "talosctl"
      # "docx2pdf" #NOTE: Needs tap
    ];

    # macOS-specific apps and those not available/stable in nixpkgs
    casks = [
      "Signal"
      "brooklyn"
      "dockdoor"
      "imageoptim"
      "moonlight"
      "parsec"
      "wireshark-app"
    ];
  };
}
