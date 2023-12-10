# Yubico

{ config, pkgs, ... }:

let
  unstable = import <nixos-unstable> {
    config = {
      allowUnfree = true;
    };
  };
in {

  environment.systemPackages = with pkgs; [
    yubikey-manager-qt
    pam_u2f
	];
}
