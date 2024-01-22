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
      # hidpi = true;
    };
  };

  environment.variables = {
    NIXOS_OZONE_WL = "1";
    NIXOS_XDG_OPEN_USE_PORTAL = "1";
    GDK_BACKEND = "wayland";
    QT_QPA_PLATFORM = "wayland";
    SDL_VIDEODRIVER = "wayland";
    ELECTRON_ENABLE_STACK_DUMPING = "true";
    ELECTRON_NO_ATTACH_CONSOLE = "true";
    XDG_SESSION_DESKTOP = "Hyprland";
    GTK_USE_PORTAL = "1";
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
		
		hyprland
    hyprland-protocols
    hyprpicker # color picker
    hyprpaper # wallpaper
		wayland
    # wayland-protocols
		xwayland
		xdg-utils # opening default programs from links
		xdg-desktop-portal
		xdg-desktop-portal-hyprland
		cliphist
    wl-clipboard
		seatd

    # launcher
		wofi
    bemoji # emoji picker

    # terminal
		alacritty
		kitty

		# status bar
		eww-wayland
    acpi
    waybar

    #screenshots
    grim
    slurp

    # qt
    libsForQt5.qt5.qtwayland
    qt6.qtwayland
    adwaita-qt
    adwaita-qt6

    # screenlock
    swaylock
    swayidle

	];
}
