{ pkgs ? import <nixpkgs> {}
# { pkgs ? import ./nix/nixpkgs.nix
# { pkgs ? import (import ./nix/nixpkgs-src) {}
, compiler ? "default"
, root ? ./.
, name ? "Graphalyze"
, source-overrides ? {}
, ...
}:
let
  haskellPackages =
    if compiler == "default"
      then pkgs.haskellPackages
      else pkgs.haskell.packages.${compiler};
in
haskellPackages.developPackage {
  root = root;
  name = name;
  source-overrides = {
    Graphalyze = ./.;
  } // source-overrides;

  overrides = self: super: with pkgs.haskell.lib; {
    # Graphalyze = dontCheck super.Graphalyze;
  };

  modifier = drv: pkgs.haskell.lib.overrideCabal drv (attrs: {
    buildTools = with haskellPackages; (attrs.buildTools or []) ++ [cabal-install ghcid] ;
    # shellHook = '' '';
  });
}
