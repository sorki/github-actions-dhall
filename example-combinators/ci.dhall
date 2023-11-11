let haskellCi =
      https://raw.githubusercontent.com/sorki/github-actions-dhall/main/haskell-ci.dhall

let defSteps = haskellCi.defaultCabalSteps

in  haskellCi.generalCi1
      ( haskellCi.withNix
          ( haskellCi.withHlint
              ( defSteps
                with extraSteps.pre
                     =
                      defSteps.extraSteps.pre
                    # [ haskellCi.BuildStep.Name
                          { name = "Pre step, added to list", run = "echo Pre" }
                      ]
                with extraSteps.post
                     =
                      defSteps.extraSteps.post
                    # [ haskellCi.BuildStep.Name
                          { name = "Post step, added to list"
                          , run = "echo Post"
                          }
                      ]
              )
          )
      )
