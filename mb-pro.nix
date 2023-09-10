# Let's see how this goes :O

{ config, pkgs, ... }:

{

  imports =
    [ # Include the results of the hardware scan.
      # <nixos-hardware/apple/macbook-pro/11-5>
    ];

  # wifi mac
  # boot.kernelModules = [ "wl" ];
  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.firewall.enable = true;
  # boot.extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];

  # The wifi broadcom driver 
  networking.enableB43Firmware = true;

  hardware.bluetooth.enable = true;
  hardware.facetimehd.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.opengl.extraPackages = [ pkgs.vaapiIntel ];

  # The wifi broadcom driver 
  # networking.enableB43Firmware = true;

  powerManagement.enable = true;

  # for mouse driver
  services.xserver.synaptics.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;
