# Let's see how this goes :O

{ config, pkgs, ... }:

{

  imports =
    [ # Include the results of the hardware scan.
      # <nixos-hardware/apple/macbook-pro/11-5>
    ];

  # wifi mac
  # boot.kernelModules = [ "wl" ];
  # boot.extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];

