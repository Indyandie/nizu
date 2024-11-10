{ config, pkgs, lib, ... }:
{
  # https://nixos.wiki/wiki/AMD_GPU

  imports = [
    # Include the results of the hardware scan.
    <nixos-hardware/apple/macbook-pro/11-5>
    <nixos-hardware/apple>
  ];

  # HIP - https://nixos.wiki/wiki/AMD_GPU#HIP
  # https://rocm.docs.amd.com/projects/HIP/en/latest/
  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  ];

  # systemd.packages = with pkgs; [
  #   auto-cpufreq
  # ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  # https://forum.manjaro.org/t/kworker-kacpid-over-70-of-cpu-dual-boot-mac-manjaro/61981
  boot = {
    kernelModules = [ "applesmc" "i915" "wl" ];
    kernelParams = [
      "hid_apple.iso_layout=0"
      "acpi_backlight=vendor"
      "acpi_mask_gpe=0x15"

      # Cause boot to be blank, no supported by this gpu
      # "radeon.si_support=0"
      # "amdgpu.si_support=1"
    ];
    extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];
    blacklistedKernelModules = [
      "nouveau"
      "nvidia"
    ]; # Disable NVIDIA video cards
    initrd.kernelModules = [ "amdgpu" ]; # AMD GPU
  };

  # wifi
  networking = {
    firewall.enable = true;
    enableB43Firmware = true; # The wifi broadcom driver     
  };

  hardware = {
    bluetooth.enable = true;
    facetimehd.enable = true;
    cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    # cpu.intel.updateMicrocode = true;

    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;

      # radv: an open-source Vulkan driver from freedesktop
      extraPackages = with pkgs; [
        ## amdvlk: an open-source Vulkan driver from AMD
        # amdvlk not supported

        ## OpenCL
        # rocmPackages.clr.icd

        ## OpenCL - Radeon
        # NOTE: at some point GPUs in the R600-family and newer
        # may need to replace this with the "rusticl" ICD;
        # and GPUs in the R500-family and older may need to
        # pin the package version or backport/patch this back in
        # - https://www.phoronix.com/news/Mesa-Delete-Clover-Discussion
        # - https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/19385
        mesa.opencl

        # accelerated graphics
        # intel-media-driver
        # intel-vaapi-driver
        # intel-gmmlib
        # intel-ocl
        # intel-compute-runtime
        vaapiIntel # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)

        libvdpau-va-gl

        ## vaapi
        vaapiVdpau
      ];

      # amd drivers
      # extraPackages32 = [ pkgs.driversi686Linux.amdvlk ]; # vulkan not supported
    };
  };

  powerManagement = {
    enable = true;
    cpuFreqGovernor = "ondemand";
    # cpuFreqGovernor = "schedutil";
  };

  services = {
    acpid.enable = true;
    mbpfan.enable = true;
    auto-cpufreq.enable = true;
    xserver.videoDrivers = [ "amdgpu" ]; # AMD GPU 

    # Enable CUPS to print documents.
    printing.enable = true;
  };

  # Accelerated Video Playback
  # nixpkgs.config.packageOverrides = pkgs: {
  #   intel-vaapi-driver = pkgs.intel-vaapi-driver.override { enableHybridCodec = true; };
  #   vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  # };


  environment = {
    variables = {
      # ROC_ENABLE_PRE_VEGA = "1"; # Required for Polaris and up
      VDPAU_DRIVER = "radeonsi";
      LIBVA_DRIVER_NAME = "radeonsi";
    };

    # pkgs
    systemPackages = with pkgs; [
      libva
      libva-utils
      libaom
      mesa
      clinfo # check OpenCL
      lact
    ];
  };

  systemd = {
    packages = with pkgs; [ lact ];
    services.lactd.wantedBy = [ "multi-user.target" ];
  };

}
