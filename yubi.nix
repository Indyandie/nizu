# Yubico

{ config, pkgs, ... }:

let
  unstable = import <nixos-unstable> {
    config = {
      allowUnfree = true;
    };
  };
in {
  security.pam.services = {
    login.u2fAuth = true;
    sudo.u2fAuth = true;
    swaylock = {};
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
