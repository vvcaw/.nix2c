{ config, pkgs, ... }:

{
    # Binary is fetched in hyprland.nix.
    home.file = {
        ".config/dunst".source = ../.dotfiles/dunst;
    };
}
