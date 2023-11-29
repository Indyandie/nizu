# hyprland

{ config, pkgs, ... }:

let
  unstable = import <nixos-unstable> {
    config = {
      allowUnfree = true;
    };
  };
in {
  programs.hyprland = {
    enable = true;
    xwayland = {
      enable = true;
      hidpi = true;
    };
  };

  environment.variables = {
    NIXOS_OZONE_WL = "1";
    GDK_BACKEND = "wayland";
    QT_QPA_PLATFORM = "wayland";
    SDL_VIDEODRIVER = "wayland";
    ELECTRON_ENABLE_STACK_DUMPING = "true";
    ELECTRON_NO_ATTACH_CONSOLE = "true";
  };

  programs.waybar.enable = true;

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
		
		unstable.hyprland
    unstable.hyprpicker
		unstable.wayland
		unstable.xwayland
		unstable.xdg-utils # opening default programs from links
		unstable.xdg-desktop-portal
		unstable.xdg-desktop-portal-hyprland
		unstable.wofi
    unstable.waybar

    acpi
		unstable.alacritty
		kitty
		seatd
		cliphist
    unstable.wl-clipboard

		# status bar
		unstable.eww-wayland

    # qt
    libsForQt5.qt5.qtwayland
    qt6.qtwayland

	];
}
