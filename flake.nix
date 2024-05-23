{
  description = "Xwayland outside your Wayland";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }: {

    packages.x86_64-linux.xwayland-satellite = (nixpkgs.legacyPackages.x86_64-linux.callPackage ./xwayland-satellite.nix { });

    packages.x86_64-linux.default = self.packages.x86_64-linux.xwayland-satellite;

  };
}
