{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";
    flake-utils.url = "github:numtide/flake-utils";
    haskell-tooling.url = "../.";
  };

  outputs = { nixpkgs, haskell-tooling, flake-utils, ... }: (flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs { inherit system; };
    in {
      devShells.default = pkgs.mkShell {
        # Note that ghc96 is not available for 22.11, but it is not a problem
        buildInputs = haskell-tooling.lib.install pkgs ["ghc96" "ghc94+hls"]
          ++ [
            pkgs.haskell.packages.ghc94.Agda
          ];
      };
    }));
}
