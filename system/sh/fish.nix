{ config, pkgs, ... }:

{
  # Enable fish shell
  programs.fish.enable = true;
  environment.shells = [ pkgs.fish ];
}