{
  inputs.haskellNix.url = "github:input-output-hk/haskell.nix";
  inputs.nixpkgs.follows = "haskellNix/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  outputs = { self, nixpkgs, flake-utils, haskellNix }:
    let
      supportedSystems = [
        "x86_64-linux"
      ];
    in
      flake-utils.lib.eachSystem supportedSystems (system:
      let
        overlays =
          [ haskellNix.overlay
              (final: prev: {
                hixProject =
                  final.haskell-nix.project {
                    src = ./.;
                    compiler-nix-name = "ghc902";
                    evalSystem = "x86_64-linux";
                  };
                }
              )
          ];
        pkgs = import nixpkgs { inherit system overlays; inherit (haskellNix) config; };
        flake = pkgs.hixProject.flake {};
      in flake // rec
           { packages =  
               { foo = flake.packages."foo:exe:foo";
                 bar = flake.packages."bar:exe:bar";
                 all = pkgs.symlinkJoin {
                   name = "all";
                   paths = with packages;
                     [ foo
                       bar
                     ];
                 };
                 default = packages.all;
               };
           }
      );

  nixConfig = {
    # This sets the flake to use the IOG nix cache.
    # Nix should ask for permission before using it,
    # but remove it here if you do not want it to.
    extra-substituters = ["https://cache.iog.io"];
    extra-trusted-public-keys = ["hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="];
    allow-import-from-derivation = true;
  };
}
#      });
#  nixConfig = {
#    # This sets the flake to use the IOG nix cache.
#    # Nix should ask for permission before using it,
#    # but remove it here if you do not want it to.
#    extra-substituters = ["https://cache.iog.io"];
#    extra-trusted-public-keys = ["hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="];
#    allow-import-from-derivation = "true";
#  };
#      in flake // rec {
#        legacyPackages = pkgs;
#        devShells =
#          { default =
#             pkgs.hixProject.shellFor {
#               tools = {
#                 cabal = "3.6.0.0"; # this is the version specified in all of the *.cabal files.
#                 haskell-language-server = "latest";
#               };
#             };
#          };
#        packages =
#          { djed-pab-operator = flake.packages."djed-pab:exe:djed-pab-operator";
#            djed-pab-user = flake.packages."djed-pab:exe:djed-pab-user";
#            djed-pab-host = flake.packages."djed-pab:exe:djed-pab-host";
#            djed-chain-index = flake.packages."djed-pab:exe:djed-chain-index";
#            djed-oracle-operator = flake.packages."djed-client:exe:djed-oracle-operator";
#            djed-stablecoin-operator = flake.packages."djed-client:exe:djed-stablecoin-operator";
#            djed-stablecoin-client = flake.packages."djed-client:exe:djed-stablecoin-client";
#            djed-client-test = flake.packages."djed-client:test:djed-client-test";
#            all = pkgs.symlinkJoin {
#              name = "all";
#              paths = with packages;
#                [ djed-pab-operator
#                  djed-pab-user
#                  djed-pab-host
#                  djed-chain-index
#                  djed-oracle-operator
#                  djed-stablecoin-operator
#                  djed-stablecoin-client
#                ];
#            };
#            default = packages.all;
#          };
