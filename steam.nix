{ pkgs, ... }:

{
  programs.steam = {
    enable = true;
    protontricks.enable = true;

    localNetworkGameTransfers.openFirewall = true;
    dedicatedServer.openFirewall = true;
    remotePlay.openFirewall = true;
  };

  hardware.steam-hardware.enable = true;
}
