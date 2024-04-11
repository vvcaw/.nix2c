{ pkgs, ... }: {
    home.packages = with pkgs; [
	appimage-run
	wireshark
        wmctrl
    ];

    home.file = {
        ".config/autostart/setvd1.desktop".source = ../.dotfiles/autostart/setvd1.desktop;
  };
}
