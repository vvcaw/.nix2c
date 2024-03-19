{ config, pkgs, ... }:

{
    programs = {
        fish = {
            enable = true;
            interactiveShellInit = ''
                set fish_greeting #Disable greeting
            '';
            plugins = [
                { name = "fishplugin-z-unstable"; src = pkgs.fishPlugins.z.src; }
                { name = "fishplugin-pure"; src = pkgs.fishPlugins.pure.src; }
            ];
        };
    };
}