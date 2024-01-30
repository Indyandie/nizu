# home-manager

{ config, pkgs, ... }:

{
  imports = [ <home-manager/nixos> ];

  home-manager.useGlobalPkgs = true;

  home-manager.users.nizusan = { pkgs, ...}: {
		 home = {
      stateVersion = "23.11";
      username = "buraku";
      homeDirectory = "/home/buraku";

      # node & npm
      packages = with pkgs; [
        dconf
        nodejs_20
        nodePackages.bash-language-server
        nodePackages.svelte-language-server
        dot-language-server
        typescript
        nodePackages_latest.typescript-language-server
        vscode-langservers-extracted
        ansible
        ansible-language-server
        marksman
        lua-language-server
        python311Packages.python-lsp-server
        yaml-language-server
        ansible-lint
        taplo # toml
        # gnome.dconf-editor
        gnome.adwaita-icon-theme
        # vscodium # doesn't work - opens and closes immediately
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

      theme = {
        name = "Materia-dark";
        package = pkgs.materia-theme;
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
