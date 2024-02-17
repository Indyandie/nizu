{ config, pkgs, lib, ... }:

let
  unstable = import <nixos-unstable> {
    config = {
      allowUnfree = true;
    };
  };
in {

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

  # optimizw
  nix.optimise.automatic = true;
  nix.optimise.dates = [ "22;30" ];
  nix.settings.auto-optimise-store = true;
  
  # env vars
  environment.variables.GTK_THEME = "Materia:dark";

  environment.pathsToLink = [
    "/share/"
  ];

#   # Steam
  
#   programs.steam = {
#     enable = true;
#     remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
#     dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
#   };

  # Sound

  # sound.mediaKeys.enable = true;
  # sound.enable = lib.mkForce false;
  # hardware.pulseaudio.enable = lib.mkForce false;
  # hardware.pulseaudio.enable = false;

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

  # Allow the user to run the light command without a password
  security.sudo.extraConfig = ''
    buraku ALL=(ALL) NOPASSWD: ${pkgs.light}/bin/light
  '';

  # mullvad vpn
  services.mullvad-vpn.enable = true;

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
        "git" "deno" "sudo" "vi-mode"
      ];
    };
  };

  users.users.nizusan = {
    shell = pkgs.zsh;
    packages = with pkgs; [];
  };

  # ssh
  services.openssh.enable = true;
  services.openssh.ports = [ 22 ];
  networking.firewall.allowedTCPPorts = [ 80 443 22 ];

  # flatpak

  services.flatpak.enable = true;
  # xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  # xdg.portal.config.common.default = "gtk";
  
  # Obsidian dependancy
  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0"
  ];

  # pkgs
  environment.systemPackages = with pkgs; [

    # editors
    helix
    vim
    obsidian

    # programs
    curl
    wget
    git
    diff-so-fancy
    starship
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
    zellij

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
    # pinentry-gtk2
    # pinentry-gnome

    # ascii
    figlet
    lolcat
    aewan

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
    # yazi # causing errors on build

    # cloud
    # dropbox

    # gtk
    gtk2
    gtk3
    gtk4
    gnome.gnome-themes-extra

    # network
    networkmanager
    networkmanagerapplet

    # vpn
    mullvad
    mullvad-vpn

    # browsers
    brave
    mullvad-browser

    # node
    # nodejs_20
    # fnm # no bueno

    # games
    # steam # trying flatpak

    # gpg
    gnupg
    keepassxc

    # media
    playerctl

    # sound
    alsa-utils
    pamixer
    sox
    sound-theme-freedesktop
    # beep # couldn't find audio device

    # backlight
    brightnessctl
    # light
    # clight
    # clightd

    # calculator
    bc

    # images
    imagemagick
    jp2a # ASCII
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
    # obs-studio
    # obs-studio-plugins.wlrobs
    # obs-studio-plugins.obs-vaapi
    (pkgs.wrapOBS {
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-backgroundremoval
        obs-pipewire-audio-capture
        obs-vaapi
      ];
    })

    # comms
    signal-desktop
  ];

  # dash
  environment.binsh = "${pkgs.dash}/bin/dash";

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs.gnupg.agent.pinentryFlavor = "gnome3";

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

  # font
  fonts.fontDir.enable = true;
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-emoji
    noto-fonts-cjk
    (nerdfonts.override {fonts = ["JetBrainsMono"];})
  ];

}
