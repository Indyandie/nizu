{ pkgs, ... }:

{
  # framework
  # fix color accuracy in power saving modes
  boot.kernelParams = [ "amdgpu.amblevel=0" ];

  # bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  ## bluetooth interface
  services.blueman.enable = true;

  ## headset controls
  systemd.user.services.mpris-proxy = {
    description = "Mpris proxy";
    after = [ "network.target" "sound.target" ];
    wantedBy = [ "default.target" ];
    serviceConfig.ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
  };

}
