# Yubico

{ pkgs, ... }:

{
  security.pam.services = {
    login.u2fAuth = true;
    sudo.u2fAuth = true;
  };

  security.pam.yubico = {
    enable = true;
    debug = true;
    mode = "challenge-response";
    id = [ "" ];
  };

  environment.systemPackages = with pkgs; [
    yubikey-manager-qt
    pam_u2f
    yubikey-manager
    yubico-pam
  ];
}
