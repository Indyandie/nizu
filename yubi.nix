# Yubico

{ pkgs, ... }:

{
  security.pam.services = {
    login = {
      u2fAuth = true;
      unixAuth = true;
      yubicoAuth = true;
    };
    sudo = {
      u2fAuth = true;
      unixAuth = true;
      yubicoAuth = true;
    };
    hyprlock = {
      unixAuth = true;
      yubicoAuth = true;
    };
  };

  security.pam.yubico = {
    enable = true;
    debug = true;
    mode = "challenge-response";
  };

  environment.systemPackages = with pkgs; [
    yubikey-manager-qt
    pam_u2f
    yubikey-manager
    yubico-pam
  ];
}
