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
    ./mb-pro.nix
    ./yubi.nix
  ];

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';

    # optimise
    optimise = {
      automatic = true;
      dates = [ "22:30" ];
    };
    settings.auto-optimise-store = true;

    # garbage clean up
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 3d";
    };
  };

  environment = {
    # env vars
    ## gtk
    # variables.GTK_THEME = "rose-pine-moon-gtk";

    # dash
    binsh = "${pkgs.dash}/bin/dash";

    pathsToLink = [
      "/share/"
    ];

    # gtk
    etc = {
      "xdg/gtk-2.0/gtkrc".text = ''
        gtk-theme-name=rose-pine-gtk
      '';

      "xdg/gtk-3.0/settings.ini".text = ''
        [Settings]
        gtk-theme-name=rose-pine-gtk
        gtk-icon-theme-name=rose-pine-moon-icons
        gtk-font-name=JetBrainsMono Nerd Font 16
        gtk-cursor-theme-name=BreezeX-RosePine-Linux
        gtk-cursor-theme-size=48
        gtk-toolbar-style=GTK_TOOLBAR_ICONS
        gtk-toolbar-icon-size=GTK_ICON_SIZE_LARGE_TOOLBAR
        gtk-button-images=0
        gtk-menu-images=0
        gtk-enable-event-sounds=1
        gtk-enable-input-feedback-sounds=0
        gtk-xft-antialias=1
        gtk-xft-hinting=1
        gtk-xft-hintstyle=hintmedium
        gtk-xft-rgba=rgb
        gtk-application-prefer-dark-theme=true
      '';
    };

  };

  security.rtkit.enable = true;

  boot = {
    extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];
    kernelModules = [ "v4l2loopback" ];
    extraModprobeConfig = "options v4l2loopback exclusive_caps=1 video_nr=9 card_label=\"obs\"";
  };

  # qt
  qt = {
    enable = true;
    style = "adwaita-dark";
    platformTheme = "gnome";
  };

  services = {
    ## thumbnails
    tumbler.enable = true;

    # usb
    gvfs.enable = true; # auto mount usb
    udisks2.enable = true;
    devmon.enable = true;

    # dbus
    dbus.enable = true;

    # flatpak
    flatpak.enable = true;

    # cronjob
    cron.enable = true;

    pipewire = {
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

    # mullvad vpn
    mullvad-vpn = {
      enable = true;
      package = unstable.pkgs.mullvad;
      enableExcludeWrapper = false;
    };
  };

  users = {
    # zsh
    defaultUserShell = pkgs.zsh;

    # users
    users.nizusan = {
      shell = pkgs.zsh;

      packages = with pkgs; [
        # node & npm
        nodePackages_latest.nodejs # ver 23 causes issues

        # js
        unstable.typescript
        unstable.svelte-language-server
        unstable.astro-language-server

        # html
        emmet-ls
        unstable.vscode-langservers-extracted
        unstable.tailwindcss-language-server

        # sh
        unstable.dot-language-server
        shfmt
        unstable.bash-language-server
        unstable.ansible
        unstable.ansible-lint
        unstable.ansible-language-server

        # md
        unstable.marksman
        unstable.ltex-ls

        # py
        python311Packages.python-lsp-server
        python311Packages.black

        # lua
        unstable.lua-language-server

        # sql
        sqls
        python311Packages.sqlparse

        # yaml
        unstable.yaml-language-server

        # toml
        unstable.taplo

        # browser
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

        # sounds
        sound-theme-freedesktop

        # comms
        signal-desktop

        # API Testing
        bruno

        # epub
        foliate

        # typst
        typst-lsp
        typstfmt

        # ascii
        ascii-draw

        ## css
        lightningcss

        ## pdf
        evince

        #svg
        inkscape-with-extensions
      ];
    };
  };

  programs = {
    ## xfce thunar
    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-volman
      ];
    };

    # light
    light.enable = true;

    # zsh
    zsh = {
      enable = true;
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

    # nvim
    neovim = {
      enable = true;
      withNodeJs = true;
    };

    # firefox
    firefox = {
      enable = true;
      package = pkgs.firefox;
    };
  };

  # run a non-nixos executable on NixOs
  # https://unix.stackexchange.com/questions/522822/different-methods-to-run-a-non-nixos-executable-on-nixos

  # programs.nix-ld.enable = true;

  # programs.nix-ld.libraries = options.programs.nix-ld.libraries.default ++ (with pkgs; [
  #   stdenv.cc.cc
  #   openssl
  #   xorg.libXcomposite
  #   xorg.libXtst
  #   xorg.libXrandr
  #   xorg.libXext
  #   xorg.libX11
  #   xorg.libXfixes
  #   libGL
  #   libva
  #   xorg.libxcb
  #   xorg.libXdamage
  #   xorg.libxshmfence
  #   xorg.libXxf86vm
  #   libelf

  #   # Required
  #   glib
  #   gtk2
  #   bzip2

  #   # Without these it silently fails
  #   alsa-lib
  #   xorg.libICE
  #   xorg.libSM
  #   xorg.libX11
  #   xorg.libXScrnSaver
  #   xorg.libXau
  #   xorg.libXcursor
  #   xorg.libXdmcp
  #   xorg.libXext
  #   xorg.libXfixes
  #   xorg.libXi
  #   xorg.libXinerama
  #   xorg.libXrandr
  #   xorg.libXrender
  #   xorg.libXxf86vm
  #   xorg.libxcb
  #   udev
  #   gnome2.GConf
  #   nspr
  #   nss
  #   cups
  #   libcap
  #   SDL2
  #   SDL2.dev
  #   libusb1
  #   dbus-glib

  #   # Only libraries are needed from those two
  #   libudev0-shim

  #   # Verified games requirements
  #   xorg.libXt
  #   xorg.libXmu
  #   libogg
  #   libvorbis
  #   SDL
  #   SDL2_image
  #   glew110
  #   libidn
  #   tbb

  #   # Other things from runtime
  #   flac
  #   freeglut
  #   libjpeg
  #   libpng
  #   libpng12
  #   libsamplerate
  #   libmikmod
  #   libtheora
  #   libtiff
  #   pixman
  #   speex
  #   SDL_image
  #   SDL_ttf
  #   SDL_mixer
  #   SDL2_ttf
  #   SDL2_mixer
  #   libappindicator-gtk2
  #   libdbusmenu-gtk2
  #   libindicator-gtk2
  #   libcaca
  #   libcanberra
  #   libgcrypt
  #   libvpx
  #   librsvg
  #   xorg.libXft
  #   libvdpau
  #   gnome2.pango
  #   cairo
  #   atk
  #   gdk-pixbuf
  #   fontconfig
  #   freetype
  #   dbus
  #   alsaLib
  #   expat
  #   # Needed for electron
  #   libdrm
  #   mesa
  #   libxkbcommon

  #   wayland
  #   xwayland
  # ]);

  # pkgs
  environment.systemPackages = with pkgs; [

    # nixos
    # nix-du

    # gpg
    keepassxc

    # editors
    unstable.helix

    # bash lsp
    unstable.bash-language-server

    # nix lsp & formatter
    nixpkgs-fmt
    nil

    # programs
    gh
    lazygit # tui
    file # MIME
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
    unstable.macchina # neofetch
    bat # cat
    bat-extras.prettybat
    bat-extras.batwatch
    bat-extras.batman
    bat-extras.batpipe
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
    # unstable.qsv

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
    fortune-kind
    chafa

    # unicode
    uni

    # fonts
    font-manager

    # files and drives
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
    gnome.adwaita-icon-theme
    dconf
    unstable.nwg-look
    glib

    # network
    networkmanager
    networkmanagerapplet

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

    # (pkgs.ffmpeg-full.override {
    #   withHeadlessDeps = true;
    #   withSmallDeps = true;
    #   withUnfree = pkgs.config.allowUnfree;

    #   withCuda = false;
    #   withCudaLLVM = false;
    #   withNvdec = false;
    #   withNvenc = false;
    #   withVdpau = false;

    #   withAlsa = false;
    #   withPulse = false;
    #   withSdl2 = false;

    #   withFontconfig = false;
    #   withFreetype = false;
    #   withSsh = false;

    #   withOpencl = true;

    #   withAom = true;
    #   withRav1e = true;
    #   withSvtav1 = !pkgs.stdenv.isAarch64;
    #   withTheora = false;
    #   withXvid = false;

    #   withVoAmrwbenc = true;
    #   withOpencoreAmrnb = true;
    #   withGsm = true;
    #   withGme = true;
    #   withFdkAac = true;

    #   withWebp = true;
    #   withSvg = true;
    #   withOpenjpeg = true; # jpeg2000 de/encoder

    #   withXml2 = true;
    #   withBluray = true;

    #   withVmaf = !pkgs.stdenv.isAarch64;

    #   # filter
    #   withVidStab = true;
    #   withGrayscale = true;
    #   withLadspa = true;
    # })
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
    # asciidoctor-with-extensions

    # epub
    bk

    # browser
    w3m-nox

    # odin
    odin
    ols

    # android
    android-udev-rules

  ];


  # font
  fonts = {
    fontDir.enable = true;

    packages = with pkgs; [
      noto-fonts
      noto-fonts-emoji
      noto-fonts-cjk
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
      atkinson-hyperlegible
      jetbrains-mono
    ];
  };
}

