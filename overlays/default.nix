final: prev:
let
  inherit (final) lib;
  json = lib.importJSON ../pkgs/generated.json;
in
{
  spicetify = rec {
    inherit (json) snippets;

    fetcher = final.callPackage ../pkgs/fetcher { };
    sources = final.callPackages ../pkgs/npins/sources.nix { };
    spicetifyBuilder = final.callPackage ../pkgs/spicetifyBuilder.nix { };
    extensions = final.callPackages ../pkgs/extensions.nix { inherit sources; };
    themes = final.callPackages ../pkgs/themes.nix { inherit sources; };
    apps = final.callPackages ../pkgs/apps.nix { inherit sources; };

    docs = final.callPackage ../docs/package.nix { };
  };
}
