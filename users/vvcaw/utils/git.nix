{ config, pkgs, ... }:

{
    home.packages = with pkgs; [
        git
    ];

    home.file = {
        ".gitconfig".source = ../.dotfiles/git/.gitconfig;
  };
}