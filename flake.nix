{
  description = "nizu flakes";

  # TODO: make this flake pure

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    # zen-browser.url = "github:0xc000022070/zen-browser-flake";
  };

  outputs =
    { self
    , nixpkgs
    , nixos-hardware
    , nixpkgs-unstable
    # , zen-browser
      # inputs
    , ...
    }@attrs:
    {
      nixosConfigurations.nizusama = nixpkgs.lib.nixosSystem {
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
          nixos-hardware.nixosModules.apple-macbook-pro-11-5
          ./configuration.nix
          # {
          #   environment.systemPackages = [
          #     # output packages
          #     zen-browser.packages.x86_64-linux.default
          #   ];
          # }
        ];
      };
    };
}
