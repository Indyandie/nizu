{ config, pkgs, lib, ... }:
{

  imports = [
    # Include the results of the hardware scan.
    <nixos-hardware/apple/macbook-pro/11-5>
    <nixos-hardware/apple>
  ];

  # systemd.packages = with pkgs; [
  #   auto-cpufreq
  # ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  # https://forum.manjaro.org/t/kworker-kacpid-over-70-of-cpu-dual-boot-mac-manjaro/61981
  boot = {
    kernelModules = [ "applesmc" "i915" "wl" ];
    kernelParams = [ "hid_apple.iso_layout=0" "acpi_backlight=vendor" "acpi_mask_gpe=0x15" ];
    extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];
    blacklistedKernelModules = [ "nouveau" "nvidia" ]; # Disable NVIDIA video cards
    initrd.kernelModules = [ "amdgpu" ];
  };

  # wifi
  networking = {
    firewall.enable = true;
    enableB43Firmware = true; # The wifi broadcom driver     
  };

  hardware.bluetooth.enable = true;
  hardware.facetimehd.enable = true;
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  # hardware.cpu.intel.updateMicrocode = true;

  powerManagement.enable = true;
  powerManagement.cpuFreqGovernor = "ondemand";
  # powerManagement.cpuFreqGovernor = "schedutil";

  services.acpid.enable = true;
  services.mbpfan.enable = true;
  services.auto-cpufreq.enable = true;

  # Accelerated Video Playback

  nixpkgs.config.packageOverrides = pkgs: {
    intel-vaapi-driver = pkgs.intel-vaapi-driver.override { enableHybridCodec = true; };
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  };

  hardware.opengl = {
    enable = true;
    #   #   ## radv: an open-source Vulkan driver from freedesktop
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      ## amdvlk: an open-source Vulkan driver from AMD
      amdvlk

      ## vaapi
      # intel-vaapi-driver
      # vaapiIntel # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      #   intel-compute-runtime

      #   intel-media-driver # LIBVA_DRIVER_NAME=iHD
      #   intel-ocl
      #   vaapiVdpau
      #   libvdpau-va-gl
      #   rocmPackages.clr.icd
    ];

    # amd drivers
    extraPackages32 = [ pkgs.driversi686Linux.amdvlk ];
  };

  environment.variables = {
    ROC_ENABLE_PRE_VEGA = "1";
  };

  services.xserver.videoDrivers = [ "amdgpu" ];

  # pkgs
  environment.systemPackages = with pkgs; [
    libva
    libva-utils
    libaom
    mesa
  ];

  # Enable CUPS to print documents.
  services.printing.enable = true;
}
