{ pkgs, lib, ifFw16 ? false, ... }:

{

  # mullvad vpn
  services.mullvad-vpn = lib.mkMerge [
    {
      enable = true;
      enableExcludeWrapper = false;
    }

    (lib.mkIf ifFw16 {
      package = pkgs.unstable.mullvad;
      gui = {
        enable = true;
        package = pkgs.unstable.mullvad-vpn;
      };
    })
  ];

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
