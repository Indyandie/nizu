# Let's see how this goes :O

{ config, pkgs, lib, ... }:

{

  imports =
    [ # Include the results of the hardware scan.
      # <nixos-hardware/apple/macbook-pro/11-5>
      <nixos-hardware/apple>
    ];
  
  systemd.packages = with pkgs; [
    auto-cpufreq
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  # wifi mac
  # boot.kernelModules = [ "wl" ];
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.firewall.enable = true;
  # boot.extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];

  # The wifi broadcom driver 
  networking.enableB43Firmware = true;

  hardware.bluetooth.enable = true;
  hardware.facetimehd.enable = true;
  # hardware.pulseaudio.enable = true;

  # The wifi broadcom driver 
  # networking.enableB43Firmware = true;

  powerManagement.enable = true;
  services.acpid.enable = true;
  # powerManagement.cpuFreqGovernor = "schedutil";
  powerManagement.cpuFreqGovernor = "ondemand";
  services.mbpfan.enable = true;
  services.auto-cpufreq.enable = true;
  # hardware.cpu.intel.updateMicrocode = true;
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  boot.blacklistedKernelModules = [ "nouveau" "nvidia" ]; # Disable NVIDIA video cards

  # Accelerated Video Playback

  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  };  

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      intel-compute-runtime
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      vaapiIntel         # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      vaapiVdpau
      libvdpau-va-gl
      amdvlk 
      intel-ocl 
      # intel-vaapi-driver
      rocmPackages.clr.icd
    ];
  };

  # hardware.opengl.extraPackages32 = with pkgs.pkgsi686Linux; [ 
  #   vaapiIntel 
  #   intel-media-driver
  #   intel-vaapi-driver
  #   amdvlk
  # ];

  # opencl

  environment.variables = {
    ROC_ENABLE_PRE_VEGA = "1";
  };

  boot.initrd.kernelModules = [ "amdgpu" ];

  services.xserver.videoDrivers = [ "amdgpu"];

  # # amd drivers

  # hardware.opengl = {
  #   ## radv: an open-source Vulkan driver from freedesktop
  #   driSupport = true;
  #   driSupport32Bit = true;

  #   ## amdvlk: an open-source Vulkan driver from AMD
  #   extraPackages = [ pkgs.amdvlk ];
  #   extraPackages32 = [ pkgs.driversi686Linux.amdvlk ];
  # };

  # pkgs
  environment.systemPackages = with pkgs; [
    # vaapi
    libva
    libva-utils
    libaom
    mesa
  ];

  boot = {
  kernelModules = [ "applesmc" "i915" ];
    # https://forum.manjaro.org/t/kworker-kacpid-over-70-of-cpu-dual-boot-mac-manjaro/61981
    kernelParams = [ "hid_apple.iso_layout=0" "acpi_backlight=vendor" "acpi_mask_gpe=0x15" ];
  };

  # for mouse driver
  # services.xserver.synaptics.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;
}
