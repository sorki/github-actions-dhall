let haskellCi =
      ./haskell-ci.dhall

in    haskellCi.generalCi
        haskellCi.matrixSteps
        ( Some
            { ghc =
              [ haskellCi.GHC.GHC963
              , haskellCi.GHC.GHC947
              , haskellCi.GHC.GHC928
              ]
            , cabal = [ haskellCi.Cabal.Cabal310 ]
            }
        )
    : haskellCi.CI.Type
