---
title: Usage
---
# {{ $frontmatter.title }}


Add this flake as an input

```nix
spicetify-nix.url = "github:Gerg-L/spicetify-nix";
```

> [!IMPORTANT]
> For 24.11 use "github:Gerg-L/spicetify-nix/24.11" instead!

or `import` the base of this repo with a `fetchTarball` passing `pkgs`

like `import (builtins.fetchTarball { ... } ) {inherit pkgs;}`

Then use one of the modules or `spicetify-nix.lib.mkSpicetify`

### Wrapper function

The wrapper takes two arguments `pkgs` and then an attribute set of config
options

```nix
let
  spicetify = spicetify-nix.lib.mkSpicetify pkgs {
    #config options
  };
in {
...
```

then add it to `environment.systemPackages` or `users.users.<name>.packages` or
anywhere you can add a package

### Modules

Import `spicetify-nix.<module>.spicetify` into your config

Where `<module>` is:

`nixosModules` for NixOS,

`darwinModules` for nix-darwin

`homeManagerModules`for home-manager

```nix
imports = [
  # Example for NixOS
  spicetify-nix.nixosModules.spicetify 
];
```

and use the `programs.spicetify` options

```nix
programs.spicetify = {
  enable = true;
  #config options
```

and it'll install the wrapped spotify to `environment.systemPackages` or
`home.packages`

Alternatively set `programs.spicetify.enable = false;` and add
`config.programs.spicetify.spicedSpotify` where you want manually

> [!IMPORTANT]
> Don't install `pkgs.spotify` anywhere The module installs spotify for you!

### Applying the overlay

The flake provides an overlay that adds all spicetify packages under `pkgs.spicetify`:

```nix
{
  inputs.spicetify-nix.url = "github:Gerg-L/spicetify-nix";

  outputs = { nixpkgs, spicetify-nix, ... }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      overlays = [ spicetify-nix.overlays.default ];
    };
  in {
    # Now pkgs.spicetify.<package> is available
  };
}
```

### Example Configuration

```nix
   programs.spicetify = {
     enable = true;
     enabledExtensions = with pkgs.spicetify.extensions; [
       adblockify
       hidePodcasts
       shuffle # shuffle+ (special characters are sanitized out of extension names)
     ];
     theme = pkgs.spicetify.themes.catppuccin;
     colorScheme = "mocha";
   }
```
