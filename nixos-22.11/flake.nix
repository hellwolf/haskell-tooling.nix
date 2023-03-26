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
        buildInputs = haskell-tooling.lib.install pkgs ["ghc96" "ghc94+hls" "ghc92+hls"];
      };
    }));
}
