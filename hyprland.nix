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
    # Ozone Wayland not working https://discourse.nixos.org/t/electron-apps-work-only-with-disable-gpu/63851
    # NIXOS_OZONE_WL = "1";
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
    rofi-wayland
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
    qt6.qtwayland
    adwaita-qt
    adwaita-qt6
    # hyprland-qt-support  # https://wiki.hyprland.org/Hypr-Ecosystem/hyprland-qt-support/

    hyprpolkitagent

    # night shift
    # hyprshade
    unstable.hyprsunset

    # hyprsysteminfo # https://wiki.hyprland.org/Hypr-Ecosystem/hyprsysteminfo/
  ];
}
