# home-manager

{ ... }:


let
  unstable = import <nixos-unstable> {
    config = {
      allowUnfree = true;
    };
  };
in
{
  imports = [
    <home-manager/nixos>
  ];

  home-manager.useGlobalPkgs = true;
  home-manager.backupFileExtension = "backup";

  home-manager.users.nizusan = { pkgs, ... }: {
    programs.neovim.enable = true;
    programs.neovim.withNodeJs = true;

    home = {
      stateVersion = "23.05";
      username = "nizusan";
      homeDirectory = "/home/nizusan";


      # node & npm
      packages = with pkgs; [
        dconf
        nodePackages_latest.nodejs
        # nodePackages_latest.bash-language-server
        nodePackages_latest.svelte-language-server
        nodePackages_latest.jsdoc
        nodePackages_latest.typescript-language-server
        typescript
        nodePackages_latest.prettier
        nodePackages_latest.vscode-html-languageserver-bin
        nodePackages_latest.sql-formatter
        typescript
        dot-language-server
        vscode-langservers-extracted
        ansible
        ansible-language-server
        marksman
        ltex-ls
        lua-language-server
        yaml-language-server
        ansible-lint
        taplo # toml
        tailwindcss-language-server

        # html
        emmet-ls

        # py
        python311Packages.python-lsp-server
        python311Packages.black

        # sql
        sqls
        python311Packages.sqlparse

        # bash
        shfmt

        # gnome.dconf-editor
        gnome.adwaita-icon-theme

        # editors
        # vscodium # doesn't work - opens and closes immediately

        # neovim dependency
        gcc
        # cl
        # rocmPackages.llvm.clang
        # zig

        # rust
        rustup

        # data sync
        syncthing
        localsend

        # vpn
        # unstable.mullvad-vpn

        # markdown
        libsForQt5.ghostwriter

        # email
        unstable.protonmail-desktop

        # notes
        unstable.obsidian

        # vpn
        # mullvad
        unstable.mullvad-vpn

        # browsers
        brave
        mullvad-browser

        # gpg
        keepassxc

        # sounds
        sound-theme-freedesktop

        # comms
        signal-desktop

        # API Testing
        unstable.bruno

        # pico8
        steam-run

        # epub
        foliate

        # typst
        typst-lsp
        typstfmt

        # ascii
        ascii-draw

        ## gtk
        themechanger

        ## css
        lightningcss
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
        # name = "Arc-dark";
        # package = pkgs.arc-theme;
        name = "Materia-dark";
        package = pkgs.materia-theme;
        # name = "Pop-Dark";
        # package = pkgs.pop-gtk-theme;
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
