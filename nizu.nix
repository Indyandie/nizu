{ config, options, pkgs, ... }:

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
  programs.light.enable = true;
  # systemd.services.clightd = {
  #   enable = true;
  #   description = "Clight daemon";
  #   serviceConfig = {
  #     ExecStart = "${pkgs.clightd}/bin/clightd -d";
  #     User = "nizusan";
  #   };
  # };

  # mullvad vpn
  services.mullvad-vpn.enable = true;
  services.mullvad-vpn.package = unstable.pkgs.mullvad;
  services.mullvad-vpn.enableExcludeWrapper = false;

  # qt
  qt.enable = true;
  qt.style = "adwaita-dark";
  qt.platformTheme = "gnome";

  # dbus
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
  users.users.nizusan = {
    shell = pkgs.zsh;
    # packages = with pkgs; [];
  };

  # flatpak
  services.flatpak.enable = true;

  # run a non-nixos executable on NixOs
  # https://unix.stackexchange.com/questions/522822/different-methods-to-run-a-non-nixos-executable-on-nixos

  programs.nix-ld.enable = true;

  programs.nix-ld.libraries = options.programs.nix-ld.libraries.default ++ (with pkgs; [
    stdenv.cc.cc
    openssl
    xorg.libXcomposite
    xorg.libXtst
    xorg.libXrandr
    xorg.libXext
    xorg.libX11
    xorg.libXfixes
    libGL
    libva
    xorg.libxcb
    xorg.libXdamage
    xorg.libxshmfence
    xorg.libXxf86vm
    libelf

    # Required
    glib
    gtk2
    bzip2

    # Without these it silently fails
    alsa-lib
    xorg.libICE
    xorg.libSM
    xorg.libX11
    xorg.libXScrnSaver
    xorg.libXau
    xorg.libXcursor
    xorg.libXdmcp
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXinerama
    xorg.libXrandr
    xorg.libXrender
    xorg.libXxf86vm
    xorg.libxcb
    udev
    gnome2.GConf
    nspr
    nss
    cups
    libcap
    SDL2
    SDL2.dev
    libusb1
    dbus-glib

    # Only libraries are needed from those two
    libudev0-shim

    # Verified games requirements
    xorg.libXt
    xorg.libXmu
    libogg
    libvorbis
    SDL
    SDL2_image
    glew110
    libidn
    tbb

    # Other things from runtime
    flac
    freeglut
    libjpeg
    libpng
    libpng12
    libsamplerate
    libmikmod
    libtheora
    libtiff
    pixman
    speex
    SDL_image
    SDL_ttf
    SDL_mixer
    SDL2_ttf
    SDL2_mixer
    libappindicator-gtk2
    libdbusmenu-gtk2
    libindicator-gtk2
    libcaca
    libcanberra
    libgcrypt
    libvpx
    librsvg
    xorg.libXft
    libvdpau
    gnome2.pango
    cairo
    atk
    gdk-pixbuf
    fontconfig
    freetype
    dbus
    alsaLib
    expat
    # Needed for electron
    libdrm
    mesa
    libxkbcommon

    wayland
    xwayland
  ]);

  # pkgs
  environment.systemPackages = with pkgs; [

    # editors
    vim
    unstable.helix

    # bash lsp
    unstable.bash-language-server

    # nix lsp & formatter
    nixpkgs-fmt
    nil

    # programs
    curl
    wget
    file # MIME
    git
    lazygit # tui
    gh
    diff-so-fancy
    difftastic
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
    # clipboard-jh # copy pasta # https://github.com/Slackadays/Clipboard/issues/171
    glow
    atuin # shell history

    # multiplexer
    unstable.zellij

    # data
    unstable.dasel

    # csv
    csvkit
    csvq
    csvlens
    sc-im
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
    chafa

    # unicode
    uni

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
    loupe

    # ffmpeg
    # yanked from https://github.com/hnjae/nix-config/blob/7a3cbbd6a62c3091a78694efb5000ed0c0fcb830/modules/home-manager/generic-home/programs/80-multimedia/ffmpeg/package.nix#L4

    (pkgs.ffmpeg-full.override {
      withHeadlessDeps = true;
      withSmallDeps = true;
      withUnfree = pkgs.config.allowUnfree;

      withCuda = false;
      withCudaLLVM = false;
      withNvdec = false;
      withNvenc = false;
      withVdpau = false;

      withAlsa = false;
      withPulse = false;
      withSdl2 = false;

      withFontconfig = false;
      withFreetype = false;
      withSsh = false;

      withOpencl = true;

      withAom = true;
      withRav1e = true;
      withSvtav1 = !pkgs.stdenv.isAarch64;
      withTheora = false;
      withXvid = false;

      withVoAmrwbenc = true;
      withOpencoreAmrnb = true;
      withGsm = true;
      withGme = true;
      withFdkAac = true;

      withWebp = true;
      withSvg = true;
      withOpenjpeg = true; # jpeg2000 de/encoder

      withXml2 = true;
      withBluray = true;

      withVmaf = !pkgs.stdenv.isAarch64;

      # filter
      withVidStab = true;
      withGrayscale = true;
      withLadspa = true;
    })
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

    # letsencrypt
    certbot

    openssl

    # JS
    unstable.deno

    # markup
    pandoc
    # weasyprint
    python312Packages.weasyprint
    texliveSmall # pdflatex
    # asciidoctor # convert adoc files
    asciidoctor-with-extensions

    # epub
    bk

    # broswer
    w3m-nox
    # brave
    (brave.override {
      # https://peter.sh/experiments/chromium-command-line-switches/

      # --enable-features=VaapiVideoDecodeLinuxGL
      commandLineArgs = ''
        --ignore-gpu-blocklist
        --enable-zero-copy
        --use-gl=egl
        --use-angle=gl
        --ozone-platform=wayland
        --disable-gpu-blocklist
        --enable-gl=opengl
        --enable-features=VaapiVideoDecodeLinuxGL

      '';
    })

    # odin
    odin
    ols

    # android
    android-udev-rules
  ];

  # dash
  environment.binsh = "${pkgs.dash}/bin/dash";

  # gpg
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs.gnupg.agent.pinentryPackage = pkgs.pinentry-gnome3;

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

  services.cron.enable = true;

}

