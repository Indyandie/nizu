# hyprland

{ pkgs, ... }:

let
  unstable = import <nixos-unstable> {
    config = {
      allowUnfree = true;
    };
  };
in
{
  programs.hyprland = {
    enable = true;
    package = unstable.pkgs.hyprland;
    xwayland = {
      enable = true;
      # hidpi = true;
    };
  };

  services.hypridle = {
    enable = true;
    package = unstable.pkgs.hypridle;
  };

  programs.hyprlock = {
    enable = true;
    package = unstable.pkgs.hyprlock;
  };

  security.pam.services.hyprlock = {
    unixAuth = true;
    yubicoAuth = true;
    fprintAuth = false;
    # text = ''
    #   auth sufficient pam_unix.so try_first_pass likeauth nullok
    #   auth sufficient pam_fprintd.so
    #   auth include login
    # '';
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

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    # wlr.enable = true;

    # make gtk apps happy
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-kde
    ];
  };

  environment.systemPackages = with pkgs; [

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
    rofi-wayland
    bemoji # emoji picker
    wtype # bemoji dependency
    # wofi

    # terminal
    unstable.alacritty
    kitty

    # status bar
    eww
    acpi

    # screenshots
    grim
    unstable.slurp

    # screen-recording
    wf-recorder
    # wl-screenrec

    # qt
    libsForQt5.qt5.qtwayland
    qt6.qtwayland
    adwaita-qt
    adwaita-qt6

    # night shift
    hyprshade
  ];
}
