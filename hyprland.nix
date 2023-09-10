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
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
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
		eww
		eww-wayland
		alacritty
		kitty
		seatd
		cliphist
	];
}
