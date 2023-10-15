# hyprland

{ config, pkgs, ... }:

{
  programs.hyprland = {
    enable = true;
    xwayland = {
      enable = true;
      hidpi = true;
    };
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;

    # make gtk apps happy
    extraPortals = [ 
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-kde
      pkgs.xdg-desktop-portal-hyprland
    ];
  };

  environment.systemPackages = with pkgs; [
		
		hyprland
		wayland
		xwayland
		xdg-utils # opening default programs from links
		xdg-desktop-portal  
		xdg-desktop-portal-hyprland
		waybar
		wofi

    acpi
		alacritty
		kitty
		seatd
		cliphist

		# status bar
		eww-wayland
    waybar

    # qt
    libsForQt5.qt5.qtwayland
    qt6.qtwayland

	];
}
