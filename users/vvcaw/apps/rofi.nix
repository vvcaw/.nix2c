{ config, pkgs, ... }:

{
    # Binary is fetched in hyprland.nix.
    home.file = {
        ".config/rofi".source = ../.dotfiles/rofi;
    };
}
