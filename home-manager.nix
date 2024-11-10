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

    # firefox
    programs.firefox.enable = true;
    programs.firefox.package = pkgs.firefox;

    home = {
      stateVersion = "23.05";
      username = "nizusan";
      homeDirectory = "/home/nizusan";


      packages = with pkgs; [

        # node & npm
        nodePackages_latest.nodejs

        typescript
        vscode-langservers-extracted
        tailwindcss-language-server
        dot-language-server
        ansible
        ansible-lint
        ansible-language-server
        marksman
        ltex-ls
        lua-language-server
        yaml-language-server
        taplo # toml

        unstable.svelte-language-server
        unstable.astro-language-server


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
        unstable.bash-language-server

        dconf
        # gnome.dconf-editor
        gnome.adwaita-icon-theme

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
        mermaid-cli

        # email
        unstable.protonmail-desktop

        # notes
        unstable.obsidian

        # vpn
        # mullvad
        unstable.mullvad-vpn

        # browsers
        # brave
        # https://discourse.nixos.org/t/chrome-wayland/35395/15
        # (brave.override {
        #   # https://peter.sh/experiments/chromium-command-line-switches/

        #   # --enable-features=VaapiVideoDecodeLinuxGL
        #   commandLineArgs = ''
        #     --use-gl=angle
        #     --use-angle=gl
        #     --ozone-platform=wayland
        #     --disable-gpu-blocklist
        #     --enable-gl=opengl
        #   '';
        # })
        mullvad-browser

        # gpg
        keepassxc

        # sounds
        sound-theme-freedesktop

        # comms
        signal-desktop
        discord

        # API Testing
        bruno

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

        ## pdf
        evince

        #svg
        inkscape-with-extensions
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
