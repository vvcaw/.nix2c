{ config, pkgs, ... }:

{
  # KDE
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # Exclude default KDE applications
  environment.plasma5.excludePackages = with pkgs.libsForQt5; [
    elisa
    gwenview
    okular
    oxygen
    khelpcenter
    konsole
    plasma-browser-integration
    print-manager
  ];

  # Start KDE in wayland session (this doesn't work I think).
  services.xserver.displayManager.defaultSession = "plasma";
}