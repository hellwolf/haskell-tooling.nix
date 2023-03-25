rec {
  install = pkgs: ghcAliases : with pkgs; [
    stack
    cabal-install
    hlint
    stylish-haskell
  ] ++ (
    let ghcs = map (a: let
          a' = builtins.replaceStrings ["+hls"] [""] a;
          useHLS = a' != a;
          ghcVer = builtins.replaceStrings ["-" "."] ["" ""] haskell.compiler.${a'}.haskellCompilerName;
          vtag     = builtins.replaceStrings ["ghc"] [""] ghcVer;
        in  {
          vtag     = vtag;
          useHLS   = useHLS;
          compiler = haskell.compiler.${ghcVer};
          packages = haskell.packages.${ghcVer};
        }) ghcAliases;
        ghcsWithHLS = builtins.filter (a: a.useHLS) ghcs;
    in [
      (buildEnv {
        name = "ghc-compilers";
        ignoreCollisions = true;
        paths = map (a: a.compiler) ghcs;
      })
    ] ++ (if builtins.length ghcsWithHLS > 0 then [(haskell-language-server.override {
        supportedGhcVersions = map (a: a.vtag) ghcsWithHLS;
    })] else [])
  );
}