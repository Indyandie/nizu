{ pkgs, ... }:

{
  # wiki: https://nixos.wiki/wiki/Steam

  programs.steam = {
    enable = true;
    protontricks.enable = true;

    localNetworkGameTransfers.openFirewall = true;
    dedicatedServer.openFirewall = true;
    remotePlay.openFirewall = true;
  };

  hardware.steam-hardware.enable = true;

  # Troubleshooting
  ## Changing the driver on AMD GPUs

  # hardware = {
  #   graphics = {
  #     enable = true;
  #     enable32Bit = true;
  #   };

  #   amdgpu.amdvlk = {
  #     enable = true;
  #     support32Bit.enable = true;
  #   };
  # };

  ## AppImage Games

  programs.appimage = {
    enable = true;
    binfmt = true;
  };
}
