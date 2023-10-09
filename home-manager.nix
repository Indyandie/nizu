# home-manager

{ config, pkgs, ... }:

{
  imports = [ <home-manager/nixos> ];

  home-manager.useGlobalPkgs = true;

  home-manager.users.nizusan = { pkgs, ...}: {
		 home = {
      stateVersion = "23.05";
      packages = with pkgs; [
        dconf
        # gnome.dconf-editor
      ];

      pointerCursor = {
        name = "Simp1e-Gruvbox-Dark";
        package = pkgs.simp1e-cursors;
        size = 24;
        gtk.enable = true;
        x11.enable = true;
      };
    };


    gtk = {
      enable = true;

      font = {
        size = 12;
        name = "JetBrainsMono Nerd Font";
      };

      gtk3 = {
        extraConfig = {
          gtk-application-prefer-dark-theme = 1;
        };
      };

      gtk4 = {
        extraConfig = {
          gtk-application-prefer-dark-theme = 1;
        };
      };
    };
  };
}
