{ config, pkgs, ... }:

let
  unstable = import <nixos-unstable> {
    config = {
      allowUnfree = true;
    };
  };
in
{

  imports = [
    ./hyprland.nix
    ./home-manager.nix
    ./mb-pro.nix
    ./yubi.nix
    # ./mb-air.nix
  ];

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # optimise
  nix.optimise.automatic = true;
  nix.optimise.dates = [ "22;30" ];
  nix.settings.auto-optimise-store = true;

  # env vars
  environment.variables.GTK_THEME = "Materia:dark";

  environment.pathsToLink = [
    "/share/"
  ];

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
    wireplumber.enable = true;
    jack.enable = true; # (optional)
    socketActivation = true;
  };

  boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];
  boot.kernelModules = [ "v4l2loopback" ];
  boot.extraModprobeConfig = "options v4l2loopback exclusive_caps=1 video_nr=9 card_label=\"obs\"";

  # light
  systemd.services.clightd = {
    enable = true;
    description = "Clight daemon";
    serviceConfig = {
      ExecStart = "${pkgs.clightd}/bin/clightd -d";
      User = "buraku";
    };
  };

  # mullvad vpn
  services.mullvad-vpn.enable = true;
  services.mullvad-vpn.package = unstable.pkgs.mullvad;
  services.mullvad-vpn.enableExcludeWrapper = false;

  # qt
  qt.enable = true;
  qt.style = "adwaita-dark";
  qt.platformTheme = "gnome";

  # dbux
  services.dbus.enable = true;

  # xfce

  # thunar
  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar-volman
    ];
  };

  ## thumbnails
  services.tumbler.enable = true;

  # usb
  services.gvfs.enable = true; # auto mount usb
  services.udisks2.enable = true;
  services.devmon.enable = true;

  # garbage clean up
  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 3d";
  };

  # zsh
  users.defaultUserShell = pkgs.zsh;

  programs.zsh = {
    enable = true; # zsh
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;
    ohMyZsh = {
      enable = true;
      plugins = [
        "git"
        "deno"
        "sudo"
        "vi-mode"
      ];
    };
  };

  # users
  users.users.buraku = {
    shell = pkgs.zsh;
    # packages = with pkgs; [];
  };

  # flatpak

  services.flatpak.enable = true;

  # pkgs
  environment.systemPackages = with pkgs; [

    # editors
    vim
    unstable.helix

    # nix lsp & formatter
    nixpkgs-fmt
    nil

    # programs
    curl
    wget
    git
    lazygit # tui
    gh
    diff-so-fancy
    unstable.starship
    neofetch
    zsh
    oh-my-zsh
    eza
    dunst
    zip
    unzip
    killall
    htop
    bottom # htop
    zoxide # jump
    sd # sed
    tealdeer # tldr
    ripgrep
    fd
    libnotify
    macchina # neofetch
    bat # cat
    bat-extras.prettybat
    bat-extras.batwatch
    bat-extras.batman
    bat-extras.batpipe
    flatpak
    clipboard-jh # copy pasta
    glow
    atuin # shell history

    # multiplexer
    unstable.zellij

    # csv
    csvkit
    # qsv

    # JSON
    jq
    jql
    jqp

    # YAML
    yq

    # words
    dict

    # pinentry
    pinentry

    # ascii
    figlet
    lolcat
    aewan
    fortune-kind

    # fonts
    font-manager

    # py
    python3

    # files and drives
    xfce.thunar
    udisks
    udisks2
    udiskie
    ntfs3g
    exfat
    yazi

    # gtk
    gtk2
    gtk3
    gtk4
    gnome.gnome-themes-extra

    # network
    networkmanager
    networkmanagerapplet

    # gpg
    gnupg

    # media
    playerctl

    # sound
    alsa-utils
    pamixer
    sox
    # beep # couldn't find audio device

    # music 
    upiano

    # backlight
    brightnessctl

    # calculator
    bc

    # images
    imagemagick
    jp2a # ASCII
    ascii-image-converter
    imv # image viewer

    # video
    ffmpeg_6-full
    # unstable.ffmpeg
    # ffmpeg = pkgs.ffmpeg.override {
    #   # vaapiSupport = true;
    #   # openglSupport = true;
    # };
    wireplumber
    vlc
    clapper
    mpv
    (pkgs.wrapOBS {
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-backgroundremoval
        obs-pipewire-audio-capture
        obs-vaapi
      ];
    })

    # letsencrupt
    certbot

    openssl

    # JS
    unstable.deno

    # markup
    pandoc
  ];

  # dash
  environment.binsh = "${pkgs.dash}/bin/dash";

  # gpg
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs.gnupg.agent.pinentryFlavor = "gnome3";

  # font
  fonts.fontDir.enable = true;
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-emoji
    noto-fonts-cjk
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    atkinson-hyperlegible
    jetbrains-mono
  ];

}
