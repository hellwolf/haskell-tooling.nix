Yet Another Nix Flake For Installing Haskell Tooling
====================================================

# Examples

##

```nix
{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    haskell-tooling = {
      url = "github:hellwolf/haskell-tooling.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, flake-utils, haskell-tooling, ... }:
  (flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs { inherit system; };
    in {
      devShells.default = pkgs.mkShell {
        buildInputs = haskell-tooling.lib.install pkgs ["ghc96" "ghc94+hls" "ghc92+hls"];
      };
    }));
}
```

