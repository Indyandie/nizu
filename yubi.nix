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
  };

  security.pam.yubico = {
    enable = true;
    debug = true;
    mode = "challenge-response";
    # control = "required";
  };

  environment.systemPackages = with pkgs; [
    yubioath-flutter
    pam_u2f
    yubikey-manager
    yubico-pam
  ];
}
