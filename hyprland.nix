# hyprland

{ pkgs, ... }:
{
  programs.hyprland = {
    enable = true;
    # package = unstable.pkgs.hyprland;
    xwayland = {
      enable = true;
      # hidpi = true;
    };
  };

  services.hypridle = {
    enable = true;
  };

  programs.hyprlock = {
    enable = true;
  };

  security.pam.services.hyprlock = {
    unixAuth = true;
    yubicoAuth = true;
    fprintAuth = false;
  };

  environment.variables = {
    NIXOS_XDG_OPEN_USE_PORTAL = "1";
  };

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    wlr.enable = true;

    # make gtk apps happy
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.kdePackages.xdg-desktop-portal-kde
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
    rofi
    bemoji # emoji picker
    wtype # bemoji dependency
    # wofi

    # terminal
    unstable.alacritty
    kitty
    unstable.ghostty

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
    kdePackages.qtwayland
    adwaita-qt
    adwaita-qt6
    hyprland-qt-support  # https://wiki.hyprland.org/Hypr-Ecosystem/hyprland-qt-support/

    hyprpolkitagent

    # night shift
    # hyprshade
    unstable.hyprsunset

    # hyprsysteminfo # https://wiki.hyprland.org/Hypr-Ecosystem/hyprsysteminfo/

    # quickshell
    unstable.quickshell

    ## QT tooling
    ## https://doc.qt.io/qt-6/qtqml-tooling.html
    kdePackages.qtdeclarative ## qmlls
  ];
}
