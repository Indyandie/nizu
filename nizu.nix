{ config, pkgs, options, ... }:
{

  nix = {
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
    variables = {
      VAR_NAME_1234 = "test";
    };

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
        gtk-cursor-theme-size=18
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
    style = "gtk2";
    platformTheme = "gtk2";
  };

  services = {
    ## thumbnails
    tumbler.enable = true;

    # usb
    gvfs.enable = true; # auto mount usb
    udisks2.enable = true;
    devmon.enable = true;
    udisks2.mountOnMedia = true; # mount device to /media/

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

    dictd = {
      enable = true;

      DBs = with pkgs.dictdDBs; [
        wordnet
        wiktionary
        jpn2eng
        eng2jpn
      ];
    };

    # text expander (no worky)
    # espanso = {
    #   enable = true;
    #   package = pkgs.unstable.espanso-wayland;
    # };

  };

  users = {
    # zsh
    defaultUserShell = pkgs.zsh;

    # users
    users.nizusan = {
      shell = pkgs.zsh;

      packages = with pkgs; [
        # sounds - freedesktop
        sound-theme-freedesktop

        # node & npm
        nodejs_22

        # js
        unstable.typescript
        unstable.svelte-language-server
        unstable.astro-language-server

        ## rescript
        rescript-language-server

        # dprint
        dprint
        dprint-plugins.g-plane-malva # CSS
        dprint-plugins.g-plane-markup_fmt # Vento, Astro
        dprint-plugins.dprint-plugin-typescript
        dprint-plugins.dprint-plugin-biome # TS/JS

        # html
        html-tidy # formatter
        emmet-ls
        unstable.vscode-langservers-extracted
        unstable.tailwindcss-language-server

        # xml
        xq-xml # formatter

        # sh
        unstable.dot-language-server
        shfmt
        unstable.bash-language-server
        unstable.ansible
        unstable.ansible-lint
        # 25.11 ansible-language-server removed
        ## Removed from unstable - ansible-language-server (https://github.com/ansible/ansible-language-server?tab=readme-ov-file)repo moved to https://github.com/ansible/vscode-ansible 

        # md
        unstable.marksman
        unstable.ltex-ls

        # py
        python313Packages.python-lsp-server
        python313Packages.black

        # lua
        unstable.lua-language-server

        # sql
        sqls
        python313Packages.sqlparse

        # yaml
        unstable.yaml-language-server

        # toml
        unstable.taplo

        # bash lsp
        unstable.bash-language-server

        # snippet lsp
        simple-completion-language-server

        ## browsers

        # ladybird

        unstable.brave
        # (unstable.brave.override {
        #   # https://peter.sh/experiments/chromium-command-line-switches/
        #   # --enable-features=VaapiVideoDecodeLinuxGL
        #   commandLineArgs = ''
        #     --ignore-gpu-blocklist
        #     --enable-zero-copy
        #     --use-gl=egl
        #     --use-angle=gl
        #     --ozone-platform=wayland
        #     --disable-gpu-blocklist
        #     --enable-gl=opengl
        #     --enable-features=VaapiVideoDecodeLinuxGL
        #   '';
        # })


        # # neovim dependency
        gcc
        # cl
        # rocmPackages.llvm.clang
        # zig

        # # rust
        unstable.rustup

        # # data sync
        syncthing
        localsend

        # markdown
        kdePackages.ghostwriter
        apostrophe
        mermaid-cli

        # graphs
        gnome-graphs

        # email
        protonmail-desktop

        # notes
        unstable.obsidian
        unstable.standardnotes

        # sounds
        sound-theme-freedesktop

        # comms
        unstable.signal-desktop

        # API Testing
        bruno

        # epub
        foliate

        # typst
        tinymist
        typstyle # 25.11 typstfmt remove 

        # ascii
        unstable.ascii-draw

        ## css
        unstable.lightningcss

        ## pdf
        unstable.evince

        #svg
        inkscape-with-extensions

        # voxel
        goxel

        # games

        # rss
        gnome-feeds

        ## music player
        tauon


        ## to do
        taskwarrior3
        taskchampion-sync-server

        ## thumbnails
        ffmpegthumbnailer # Video files
        webp-pixbuf-loader # .webp images
        poppler_gi # poppler-glib - Adobe .pdf files
        haskellPackages.freetype2 # freetype2 - Font files
        libgsf # .odf files
        evince # .pdf files
        gnome-epub-thumbnailer # .epub and .mobi ebook files
        mcomix # .cbr comicbook archives
        f3d # 3D files, including glTF, stl, step, ply, obj, fbx.
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
        thunar-media-tags-plugin
        thunar-dropbox-plugin
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
        custom = "$USER/oh-my-zsh";
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
      package = pkgs.unstable.floorp-bin;
    };

    # chromium policies
    chromium = {
      enable = true;
    };

    # partition-manager.enable = true; # missing privileges
    gnome-disks.enable = true;
  };

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
    pango
    cairo
    atk
    gdk-pixbuf
    fontconfig
    freetype
    dbus
    alsa-lib # renamed
    expat
    # Needed for electron
    libdrm
    mesa
    libxkbcommon

    wayland
    xwayland

    unstable.raylib
    unstable.sdl3
    unstable.glfw
  ]);

  # pkgs
  environment.systemPackages = with pkgs; [

    # nixos
    # nix-du

    # gpg
    keepassxc

    # editors
    unstable.helix

    # nix lsp & formatter
    nixpkgs-fmt
    nil

    ## version control
    gh
    lazygit # tui
    diff-so-fancy
    difftastic
    unstable.jujutsu
    unstable.jjui

    # programs
    file # MIME
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
    unstable.qsv

    # JSON
    jq
    jql
    jqp

    # YAML
    unstable.yq-go

    # words
    dict

    # pinentry
    pinentry-qt

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
    gnome-themes-extra # renamed
    adwaita-icon-theme
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

    # video
    yt-dlp

    # backlight
    brightnessctl

    # calculator
    bc

    # images
    imagemagick
    exiftool
    jp2a # ASCII
    ascii-image-converter
    imv # image viewer
    # loupe
    eog # eye of gnome

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
    unstable.bun

    # markup
    pandoc
    # weasyprint
    python313Packages.weasyprint

    texliveSmall # pdflatex
    # asciidoctor # convert adoc files
    # asciidoctor-with-extensions

    # epub
    bk

    # browser
    w3m-nox
    unstable.chawan

    # odin
    unstable.odin
    ols

    # sdl
    unstable.sdl3
    unstable.sdl3-ttf
    unstable.sdl3-image

    # raylib
    unstable.raylib

    # opengl
    unstable.glfw

    # android
    # 25.11 android-udev-rules - has been removed due to being superseded by built-in systemd uaccess rules.
    # https://github.com/M0Rf30/android-udev-rules

    # rss tui
    unstable.newsboat

    # DNS
    dig

    # vibes 
    unstable.opencode

    # boot
    # unetbootin
  ];


  # font
  fonts = {
    fontDir.enable = true;

    packages = with pkgs; [
      noto-fonts
      noto-fonts-color-emoji
      noto-fonts-cjk-sans
      nerd-fonts.jetbrains-mono
      atkinson-hyperlegible
      jetbrains-mono
    ];
  };
}

