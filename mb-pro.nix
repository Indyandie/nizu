{ config, pkgs, lib, ... }:
{
  # CPU Model: Intel(R) Core(TM) i7-4870HQ CPU @ 2.50GHz
  # GPU: Intel Corporation Crystal Well Integrated Graphics Controller, Advanced Micro Devices, Inc. [AMD/ATI] Venus XT [Radeon HD 8870M / R9 M270X/M370X] 
  # WiFi Chipset: Broadcom Inc. and subsidiaries BCM43602 802.11ac Wireless LAN SoC
  # System Model: MacBookPro11,5

  # https://nixos.wiki/wiki/AMD_GPU
  # https://wiki.archlinux.org/title/MacBookPro11,x

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  # https://forum.manjaro.org/t/kworker-kacpid-over-70-of-cpu-dual-boot-mac-manjaro/61981
  boot = {
    extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];

    kernelModules = [
      "applesmc"
      "i915"
      "wl"
      "radeon"
    ];

    kernelParams = [
      "hid_apple.iso_layout=0"
      "acpi_backlight=vendor"
      "acpi_mask_gpe=0x15"
    ];

    blacklistedKernelModules = [
      "nouveau"
      "nvidia" # Disable NVIDIA video cards
    ];
  };

  # wifi
  networking = {
    firewall.enable = true;
    # enableB43Firmware = true; # The wifi broadcom driver     
  };

  hardware = {
    amdgpu.initrd.enable = false;
    bluetooth.enable = true;
    facetimehd.enable = true;
    cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware; # or true

    graphics = {
      enable = true;

      extraPackages = with pkgs; [
        libvdpau-va-gl

        ## vaapi
        vaapiVdpau
        mesa
      ];
    };
  };

  powerManagement = {
    enable = true;
  };

  services = {
    acpid.enable = true;
    mbpfan.enable = true;
    auto-cpufreq.enable = true;

    # Enable CUPS to print documents.
    printing.enable = true;

    # bluetooth
    blueman.enable = true;
  };

  environment = {
    variables = {
      VDPAU_DRIVER = "radeonsi";
      LIBVA_DRIVER_NAME = "radeonsi";
    };

    systemPackages = with pkgs; [
      libva
      libva-utils
      libaom
      mesa
    ];
  };

  systemd = {
    packages = with pkgs; [
      lact
      auto-cpufreq
    ];

    services.lactd.wantedBy = [ "multi-user.target" ];
  };

}
