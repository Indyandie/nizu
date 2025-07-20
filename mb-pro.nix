{ config, pkgs, lib, ... }:
{
  # CPU Model: Intel(R) Core(TM) i7-4870HQ CPU @ 2.50GHz

  # GPU: Intel Corporation Crystal Well Integrated Graphics Controller, Advanced Micro Devices, Inc. [AMD/ATI] Venus XT [Radeon HD 8870M / R9 M270X/M370X] 
  # - Intel GPU https://nixos.wiki/wiki/Intel_Graphics
  #     - The Intel Corporation Crystal Well Integrated Graphics Controller (rev 08) is part of the 4th generation Intel Core processors, known as Haswell.
  # - AMD GPU https://wiki.nixos.org/wiki/AMD_GPU
  #    - https://nixos.wiki/wiki/AMD_GPU
  #    - https://www.techpowerup.com/gpu-specs/radeon-r9-m370x-mac-edition.c2730

  # WiFi Chipset: Broadcom Inc. and subsidiaries BCM43602 802.11ac Wireless LAN SoC
  # System Model: MacBookPro11,5

  # https://nixos.wiki/wiki/AMD_GPU
  # https://wiki.archlinux.org/title/MacBookPro11,x

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  # https://forum.manjaro.org/t/kworker-kacpid-over-70-of-cpu-dual-boot-mac-manjaro/61981

  boot = {
    loader.grub.configurationLimit = 3;
    loader.systemd-boot.configurationLimit = 3;

    kernelModules = [
      "applesmc"
      "i915"
      "wl"
      # "radeon"
      # "amdgpu"
      "apple-gmux"
      "brcmfmac" # wifi
    ];

    kernelParams = [
      "hid_apple.iso_layout=0"
      "acpi_backlight=vendor"
      "acpi_mask_gpe=0x15"
      # blank boot - Southern Islands
      # "radeon.si_support=0"
      # "amdgpu.si_support=1"
      # Sea Islands
      "radeon.cik_support=0"
      "amdgpu.cik_support=1"
      "acpi_osi=Darwin"
      "brcmfmac.feature_disable=0x82000" # wifi
    ];

    blacklistedKernelModules = [
      "nouveau"
      "nvidia" # Disable NVIDIA video cards
      # "radeon" # Blacklist radeon after switch
    ];

    initrd.kernelModules = [ "amdgpu" ]; # AMD GPU
  };

  # wifi
  networking = {
    firewall.enable = true;
    # enableB43Firmware = true; # The wifi broadcom driver     
  };

  hardware = {
    amdgpu.initrd.enable = true;
    bluetooth.enable = true;
    facetimehd.enable = true;
    cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware; # or true
    enableRedistributableFirmware = true;

    graphics = {
      enable = true;
      enable32Bit = true;

      extraPackages = with pkgs; [
        libvdpau-va-gl

        libvdpau-va-gl

        ## vaapi
        vaapiVdpau
        mesa
        intel-vaapi-driver # older intel versions
        vaapiIntel # For Intel Haswell

        # open cl for older GPU using radeon, graphics cards older than GCN 1 
        mesa.opencl

        # QSV - Quick Sync Video
        intel-media-sdk
        intel-media-driver # For Intel Quick Sync

        # intel - may help with acceleration
        vaapiIntel
        intel-media-driver

        # extra amdvlk drivers
        amdvlk # Vulkan for AMD (check compatibility; may not support GCN2 fully)
        driversi686Linux.amdvlk # 32 bit apps
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
