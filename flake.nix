{
  description = "nizu flakes";

  # TODO: make this flake pure

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    # zen-browser.url = "github:MarceColl/zen-browser-flake";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = { self, nixpkgs, nixos-hardware, nixpkgs-unstable, ... }@attrs:
    {
      nixosConfigurations.nizusama = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = attrs;
        modules = [
          {
            nixpkgs.overlays = [
              (final: prev: {
                # unstable = nixpkgs-unstable.legacyPackages.${prev.system};
                # use this variant if unfree packages are needed:
                unstable = import nixpkgs-unstable {
                  # inherit prev.system;
                  inherit (final) system;
                  config.allowUnfree = true;
                };
              })
            ];
          }
          nixos-hardware.nixosModules.apple-macbook-pro-11-5
          ./configuration.nix
        ];
      };
    };

  # https://github.com/MarceColl/zen-browser-flake
  # add zen-browser to ./configuration.nix import 
  # [ zen-browser, ...]
  # add zen-browser.packages."${system}".default packages
}
