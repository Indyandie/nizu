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

  environment.systemPackages = with pkgs; [
    yubikey-manager-qt
    pam_u2f
	];
}
