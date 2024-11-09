{ pkgs, lib, vars, ... }:
{
  # Homebrew for macOS-specific and unavailable packages
  homebrew = {
   taps = [];

    # Mac App Store apps
    masApps = {};

    # Homebrew formulae (CLI tools)
    brews = [
      # "docx2pdf" ##TODO: Needs tap
      "iperf3"

    ];

    # macOS-specific apps and those not available/stable in nixpkgs
    casks = [
      "brooklyn"
      "dockdoor"
      "imageoptim"
      "parsec"
      "shortcat"
    ];
  };
}

