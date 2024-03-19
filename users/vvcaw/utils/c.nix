{ config, pkgs, ... }:

{
    home.packages = with pkgs; [
        zlib
    ];
}