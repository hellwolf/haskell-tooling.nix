rec {
  parseSpec = pkgs: a: let
    a' = builtins.replaceStrings ["+hls"] [""] a;
    useHLS = a' != a;
    ghcExist = builtins.hasAttr a' pkgs.haskell.compiler;
  in { inherit ghcExist; } // (if ghcExist then let
    ghcVer = builtins.replaceStrings ["-" "."] ["" ""] pkgs.haskell.compiler.${a'}.haskellCompilerName;
    vtag   = builtins.replaceStrings ["ghc"] [""] ghcVer;
  in {
    inherit useHLS vtag;
    compiler = pkgs.haskell.compiler.${ghcVer};
    packages = pkgs.haskell.packages.${ghcVer};
  } else {});

  install = pkgs: specs : with pkgs; [
    stack
    cabal-install
    hlint
    stylish-haskell
  ] ++ (
    let ghcs = builtins.filter (a: a.ghcExist) (map (parseSpec pkgs) specs);
        ghcsWithHLS = builtins.filter (a: a.useHLS) ghcs;
    in [
      (buildEnv {
        name = "ghc-pkgs";
        ignoreCollisions = true;
        paths = map (a: a.compiler) ghcs;
      })
      (buildEnv {
        name = "haskell-language-server-pkgs";
        ignoreCollisions = true;
        paths = map (a:
          a.packages.haskell-language-server
        ) ghcsWithHLS;
      })
    ]);
}
