{ config, pkgs, ... }:

{
    home.packages = with pkgs; [
        alejandra
	etcher
    ];
}
