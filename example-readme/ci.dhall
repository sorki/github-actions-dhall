let haskellCi =
      https://raw.githubusercontent.com/sorki/github-actions-dhall/main/haskell-ci.dhall

in    haskellCi.generalCi
        haskellCi.defaultCabalSteps
        haskellCi.DhallMatrix::{
        , ghc =
          [ haskellCi.GHC.GHC9103, haskellCi.GHC.GHC984, haskellCi.GHC.GHC967 ]
        , cabal = [ haskellCi.Cabal.Cabal316, haskellCi.Cabal.Cabal314 ]
        , os = [ haskellCi.OS.Ubuntu, haskellCi.OS.MacOS ]
        }
    : haskellCi.CI.Type
