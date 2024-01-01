{ config, pkgs, ... }:

{
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
             	"electron-25.9.0"
              ];
  };

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # IDE
    jetbrains.webstorm
    jetbrains.clion
    jetbrains.idea-ultimate

    kitty
    zlib
    stack
    git
    lazygit
    brave
    vscode
    element-desktop
    obsidian
    spotify
    gnome.gnome-tweaks
    gnome-extension-manager
    gnomeExtensions.switcher
    gnomeExtensions.tiling-assistant


    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    (nerdfonts.override { fonts = [ "FiraCode" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    ".config/kitty".source = .dotfiles/kitty;

    ".gitconfig".source = .dotfiles/git/.gitconfig;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
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

  programs = {
    # Fish shell
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

    # Let Home Manager install and manage itself.
    home-manager.enable = true; 
  };
}
