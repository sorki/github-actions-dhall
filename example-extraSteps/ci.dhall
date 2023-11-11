let haskellCi =
      https://raw.githubusercontent.com/sorki/github-actions-dhall/main/haskell-ci.dhall

let defSteps = haskellCi.defaultCabalSteps

in  haskellCi.generalCi1
      ( defSteps
        with extraSteps.pre
             =
              defSteps.extraSteps.pre
            # [ haskellCi.BuildStep.Name
                  { name = "Pre step, added to list", run = "echo Pre" }
              ]
        with extraSteps.postCheckout
             =
          [ haskellCi.BuildStep.Name
              { name = "Normal step"
              , run =
                  ''
                  echo "Note that we are replacing postCheckout list"
                  ''
              }
          , haskellCi.BuildStep.NameIf
              { name = "Conditional step"
              , run = "echo Hello"
              , `if` = "matrix.os == 'ubuntu-latest'"
              }
          ]
        with extraSteps.post
             =
              defSteps.extraSteps.post
            # [ haskellCi.BuildStep.Name
                  { name = "Post step, added to list", run = "echo Post" }
              ]
      )
