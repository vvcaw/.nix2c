{ config, pkgs, ... }:

{
    # Binary is fetched in hyprland.nix.
    home.file = {
        ".config/waybar".source = ../.dotfiles/waybar;
    };
}
