# home-manager

{ config, pkgs, lib, ... }:
let corepackEnable = pkgs.stdenv.mkDerivation {
    name = "corepack";
    buildInputs = [ pkgs.nodePackages_latest.nodejs ];
    phases = [ "installPhase" ];
    installPhase = ''
      mkdir -p $out/bin
      corepack enable --install-directory $out/bin
      corepack enable --install-directory $out/bin yarn
      # corepack prepare yarn@4.1.0 --activate
    '';
};
in {

  imports = [ 
    <home-manager/nixos>
  ];

  home-manager.useGlobalPkgs = true;

  home-manager.users.nizusan = { pkgs, ...}: {
    programs.neovim.enable = true;
    programs.neovim.withNodeJs = true;

    home = {
      stateVersion = "23.11";
      username = "buraku";
      homeDirectory = "/home/buraku";

      # node & npm
      packages = with pkgs; [
        dconf
        nodePackages_latest.nodejs
        corepackEnable
        # corepack_latest
        # nodePackages_latest.yarn
        # node2nix
        # yarn2nix
        nodePackages_latest.bash-language-server
        nodePackages_latest.svelte-language-server
        nodePackages_latest.typescript-language-server
        typescript
        dot-language-server
        vscode-langservers-extracted
        ansible
        ansible-language-server
        marksman
        lua-language-server
        yaml-language-server
        ansible-lint
        taplo # toml
        python311Packages.python-lsp-server
        # gnome.dconf-editor
        gnome.adwaita-icon-theme

        # editors
        # vscodium # doesn't work - opens and closes immediately

        # neovim
        gcc
        # cl
        # rocmPackages.llvm.clang
        # zig

        # rust
        rustup
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
