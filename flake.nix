# SPDX-FileCopyrightText: 2021 Serokell <https://serokell.io/>
#
# SPDX-License-Identifier: CC0-1.0

{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };
  
  inputs.flake-compat = {
    url = "github:edolstra/flake-compat";
    flake = false;
  };

  outputs = { self, nixpkgs, flake-utils, flake-compat }:

  let
    supportedSystems = [
      "x86_64-linux"
    ];
  in
    flake-utils.lib.eachSystem supportedSystems (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        haskellPackages = pkgs.haskell.packages.ghc90.override {
           overrides = self: super: rec {
             foo = self.callCabal2nix "foo" (./foo) {};
           };
        };


      in rec {
        packages =
          { foo = haskellPackages.callCabal2nix "foo" ./foo {};
            bar = haskellPackages.callCabal2nix "bar" ./bar {};
            all = pkgs.symlinkJoin {
              name = "all";
              paths = with packages;
                [ foo 
                  bar
                ];
              };
            default = packages.all;
          };
         devShells.default = pkgs.mkShell {
           buildInputs = with pkgs; [
             ghcid
             cabal-install
             ormolu
           ];
           inputsFrom = builtins.attrValues self.packages.${system};
         };
      });
}
