{ config, pkgs, ... }:

{
  programs.hyprland = {
    enable = true;
    enableNvidiaPatches = true;
    xwayland.enable = true;
  };

  environment.sessionVariables = {
    # Cursor gets invisible.
    WLR_NO_HARDWARE_CURSORS = "1";
    # Hints electron apps to use wayland.
    NIXOS_OZONE_WL = "1";
  };

  environment.systemPackages = with pkgs; [
    (waybar.overrideAttrs (oldAttrs: { mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ]; }))

    eww
    # Notification manager (pure wayland)
    dunst

    # Wallpaper
    swww
  
    rofi-wayland
    networkmanagerapplet
  ];

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  # Enable Display Manager
  services.xserver.displayManager.gdm.enable = true;
}
