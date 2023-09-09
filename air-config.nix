# macbook-air

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <nixos-hardware/apple/macbook-air/6>
      <home-manager/nixos> # home manager
    ];

  # wifi mac
  boot.kernelModules = [ "wl" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];

  # irq nobody cared
  boot.kernelParams = [ "irqpoll" ];

