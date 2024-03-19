{ config, pkgs, ... }:

{
    home.packages = with pkgs; [
        jetbrains.webstorm
        jetbrains.clion
        jetbrains.idea-ultimate
    ];
}