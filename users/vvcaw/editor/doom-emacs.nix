{ lib, config, pkgs, ... }:

{
    home.packages = with pkgs; [
      # required dependencies
      git
      emacs    # Emacs 27.2
      ripgrep
      # optional dependencies
      coreutils # basic GNU utilities
      fd
      clang
    ];

    # env.PATH = [ "$XDG_CONFIG_HOME/emacs/bin" ];

    # fonts.fonts = [ pkgs.emacs-all-the-icons-fonts ];

    # TODO: Note here that both the .emacs file and the .emacs.d directory have to be deleted, otherwise emacs will use this config instead of doom
    home.activation.doom-emacs = lib.hm.dag.entryAfter [ "installPackages" ] ''
        if [ ! -d "$HOME/.config/emacs" ]; then
        $DRY_RUN_CMD ${
          lib.getExe pkgs.git
        } clone --depth=1 --single-branch "https://github.com/doomemacs/doomemacs" "$HOME/.config/emacs"
        fi
      '';
}
