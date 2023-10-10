{ config, pkgs, lib, ... }:

{
  imports = [
    ./hyprland.nix
    ./home-manager.nix
    ./mb-pro.nix
    # ./mb-air.nix
  ];

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
  
  # Sound

  sound.mediaKeys.enable = true;
  security.rtkit.enable = true;
  sound.enable = lib.mkForce false;
  hardware.pulseaudio.enable = lib.mkForce false;
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
    wireplumber.enable = true;
    jack.enable = true; # (optional)
  };
  
  # light

  systemd.services.clightd = {
    enable = true;
    description = "Clight daemon";
    serviceConfig = {
      ExecStart = "${pkgs.clightd}/bin/clightd -d";
      User = "buraku";
    };
  };

  security.sudo.extraConfig = ''
    # Allow the user to run the light command without a password
    buraku ALL=(ALL) NOPASSWD: ${pkgs.light}/bin/light
  '';

  # mullvad vpn
  services.mullvad-vpn.enable = true;

  # dbux
  services.dbus.enable = true;

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
  
  # Console font
  console = {
    font = "${pkgs.terminus_font}/share/consolefonts/ter-132n.psf.gz";
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

  # flatpak
  services.flatpak.enable = true;

  # pkgs
  environment.systemPackages = with pkgs; [

  # editors
  helix
  vim

  # programs
  curl
  wget
  git
  starship
  neofetch
  zsh
  lsd
  dunst
  zip
  unzip
  killall
  tldr
  bat
  bat-extras.prettybat
  bat-extras.batwatch
  bat-extras.batman
  bat-extras.batpipe
  flatpak

  # files and drives
  xfce.thunar
  libsForQt5.dolphin
  udisks
  udisks2
  ntfs3g
  exfat

  # cloud
  # dropbox

  # gtk
  gtk2
  gtk3
  gtk4

  # network
  networkmanager
  networkmanagerapplet

  # vpn
  mullvad
  mullvad-vpn

  # browsers
  brave

  # node
  fnm

  # rust
  cargo
  rustc
  rust-analyzer

  # games
  # steam # trying flatpak

  # gpg
  gnupg
  keepassxc

  # sound
  alsa-utils

  # backlight
  light
  clight
  clightd

  # calculator
  bc
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

  programs.gnupg.agent.pinentryFlavor = "gtk2";

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
  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-emoji
    noto-fonts-cjk
    (nerdfonts.override {fonts = ["JetBrainsMono"];})
  ];

}
