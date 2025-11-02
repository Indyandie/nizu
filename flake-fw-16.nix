{
  description = "nizu - framework 16";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs =
    { self
    , nixpkgs
    , nixos-hardware
    , nixpkgs-unstable
      # inputs
    , ...
    }@attrs:
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = attrs;
        modules = [
          {
            nixpkgs.overlays = [
              (final: prev: {
                # unstable = nixpkgs-unstable.legacyPackages.${prev.system};
                # OR

                # use this variant if unfree packages are needed:
                unstable = import nixpkgs-unstable {
                  # inherit prev.system;
                  inherit (final) system;
                  config.allowUnfree = true;
                };
              })
            ];
          }
          nixos-hardware.nixosModules.framework-16-7040-amd
          ./configuration.nix
          ./nizu/nizu.nix

          ./nizu/fw-16-7040-amd.nix
          ./nizu/hyprland.nix
          ./nizu/steam.nix
          ./nizu/vpn.nix
          ./nizu/yubi.nix
        ];
      };
    };
}
