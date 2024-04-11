{ config, pkgs, ... }:

{
    home.packages = with pkgs; [
        jetbrains-toolbox
        jetbrains.webstorm
        jetbrains.idea-ultimate
        android-studio
    ];
}
