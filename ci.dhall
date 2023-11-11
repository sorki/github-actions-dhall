let haskellCi = ./haskell-ci.dhall

in    haskellCi.generalCi
        haskellCi.matrixSteps
        ( Some
            haskellCi.DhallMatrix::{
            , ghc =
              [ haskellCi.GHC.GHC963
              , haskellCi.GHC.GHC947
              , haskellCi.GHC.GHC928
              ]
            }
        )
    : haskellCi.CI.Type
