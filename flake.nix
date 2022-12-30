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
                    compiler-nix-name = "ghc8107";
                    evalSystem = "x86_64-linux";
                  };
                }
              )
          ];
        pkgs = import nixpkgs { inherit system overlays; inherit (haskellNix) config; };
        flake = pkgs.hixProject.flake {};
      in flake // rec
           { legacyPackages = pkgs;
             packages =  rec
               { foo = flake.packages."foo:exe:foo";
                 bar = flake.packages."bar:exe:bar";
                 foo-docker =
                   pkgs.dockerTools.buildImage {
                     name = "hello-cachix-foo";
                     config = { 
                       Cmd = [ "${foo}/bin/foo" ]; 
                     };
                 }; 
                 bar-docker =
                   pkgs.dockerTools.buildImage {
                     name = "hello-cachix-bar";
                     config = { 
                       Cmd = [ "${bar}/bin/bar" ]; 
                     };
                 }; 
                 all = pkgs.symlinkJoin {
                   name = "all";
                   paths = with packages;
                     [ foo
                       bar
                     ];
                 };
                 default = packages.all;
               };
             devShells =
               { default =
                  pkgs.hixProject.shellFor {
                    tools = {
                      cabal = "3.6.0.0"; # this is the version specified in all of the *.cabal files.
                      haskell-language-server = "latest";
                    };
                  };
               };
           }
      );

  nixConfig = {
    extra-substituters = ["https://cache.iog.io"];
    extra-trusted-public-keys = ["hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="];
    allow-import-from-derivation = true;
  };
}
