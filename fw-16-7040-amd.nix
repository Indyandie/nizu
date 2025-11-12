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


  ## prevent wakeup
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", DRIVERS=="usb", ATTRS{idVendor}=="32ac", ATTRS{idProduct}=="0012", ATTR{power/wakeup}="disabled", ATTR{driver/1-1.1.1.4/power/wakeup}="disabled"
    SUBSYSTEM=="usb", DRIVERS=="usb", ATTRS{idVendor}=="32ac", ATTRS{idProduct}=="0014", ATTR{power/wakeup}="disabled", ATTR{driver/1-1.1.1.4/power/wakeup}="disabled"
  '';

  ## Useful Utilities
  # inputmodule.enable = true;

  ## display the time on your inputmodule

  ###```shell
  #inputmodule-control   --serial-dev /dev/ttyACM1 led-matrix --clock
  ###```
}
