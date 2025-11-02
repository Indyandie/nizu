{ pkgs, ... }:

{
  # mullvad vpn
  services.mullvad-vpn = {
    enable = true;
    package = pkgs.unstable.mullvad-vpn;
    enableExcludeWrapper = false;
  };

  users.users.nizusan = {
    packages = with pkgs; [
      unstable.mullvad-browser
    ];
  };

  networking.firewall = {
    allowedTCPPorts = [
      1401
    ];

    allowedUDPPorts = [
      53
      1194
      1195
      1196
      1197
      1300
      1301
      1302
      1303
      1400
    ];
  };

}
