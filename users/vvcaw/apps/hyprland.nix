{ config, pkgs, ... }:

{
    # Binary is fetched in hyprland.nix.
    home.file = {
        ".config/hypr".source = ../.dotfiles/hypr;
    };
}
