{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, flake-utils, ... }:
    let
      lib = import ./lib.nix;
    in (flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = lib.install pkgs ["ghc96" "ghc94+hls" "ghc92+hls"];
        };
      })) // {
        inherit lib;
      };
}
