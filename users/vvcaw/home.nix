{ config, pkgs, ... }:

{
  imports = [
    ./editor/jetbrains.nix
    ./editor/vscode.nix
    ./editor/doom-emacs.nix
    ./editor/nixvim.nix
    ./editor/neovide.nix

    ./fonts/fira-code.nix

    ./sh/fish.nix

    ./utils/c.nix
    ./utils/nix.nix
    ./utils/git.nix
    ./utils/haskell.nix
    ./utils/lazygit.nix
    ./utils/wmctrl.nix

    ./browser/brave.nix

    ./apps/discord.nix
    ./apps/anki.nix
    ./apps/element.nix
    ./apps/obsidian.nix
    ./apps/spotify.nix
    ./apps/kitty.nix
    ./apps/rofi.nix
    ./apps/dunst.nix
    ./apps/waybar.nix
    ./apps/hyprland.nix
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "vvcaw";
  home.homeDirectory = "/home/vvcaw";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.

  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = (_:true);
    permittedInsecurePackages = [
             	"electron-25.9.0" # Temporary fix as electron 25 is EOL.
              ];
  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/vvcaw/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  programs.home-manager.enable = true;
}
