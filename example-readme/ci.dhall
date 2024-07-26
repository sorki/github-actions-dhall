let haskellCi =
      https://raw.githubusercontent.com/sorki/github-actions-dhall/main/haskell-ci.dhall

in    haskellCi.generalCi
        haskellCi.defaultCabalSteps
        haskellCi.DhallMatrix::{
        , ghc =
          [ haskellCi.GHC.GHC982, haskellCi.GHC.GHC966, haskellCi.GHC.GHC948 ]
        , cabal = [ haskellCi.Cabal.Cabal312, haskellCi.Cabal.Cabal310 ]
        , os = [ haskellCi.OS.Ubuntu, haskellCi.OS.MacOS ]
        }
    : haskellCi.CI.Type
