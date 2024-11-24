{
  description = "Zen Browser";

  # TODO: make this flake pure

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    zen-browser.url = "github:MarceColl/zen-browser-flake";
  };

  outputs = { self, nixpkgs, ... }@attrs: {
    nixosConfigurations.nikuzu = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs  = attrs;
      modules = [ /etc/nixos/configuration.nix ];
    };
  };

  # https://github.com/MarceColl/zen-browser-flake
  # add zen-browser to ./configuration.nix import 
  # [ zen-browser, ...]
  # add zen-browser.packages."${system}".default packages
}
