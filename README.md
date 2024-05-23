# XWayland Satellite

This is a flake for this project: https://github.com/Supreeeme/xwayland-satellite

Use this flake by adding the snippet below to your flake inputs.
```nix
    xwayland-satellite = { 
      url = "github:gabthebab/xwayland-satellite";
      inputs.nixpkgs.follows = "nixpkgs"; 
    };
```
Then you can install it by adding `inputs.xwayland-satellite.packages.x86_64-linux.default` to your installed package list.

