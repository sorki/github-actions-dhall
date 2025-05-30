let haskellCi = ./haskell-ci.dhall

let Prelude =
      https://prelude.dhall-lang.org/v23.1.0/package.dhall
        sha256:931cbfae9d746c4611b07633ab1e547637ab4ba138b16bf65ef1b9ad66a60b7f

let dhallInstall =
      haskellCi.BuildStep.Name
        { name = "Install dhall", run = "cabal install dhall" }

let dhallYamlInstall =
      haskellCi.BuildStep.Name
        { name = "Install dhall-to-yaml &c.", run = "cabal install dhall-yaml" }

let checkDhall =
      λ(dhalls : List Text) →
        haskellCi.BuildStep.Name
          { name = "Check Dhall"
          , run =
                  ''
                  export PATH=$HOME/.cabal/bin:$PATH
                  ''
              ++  Prelude.Text.concatMap
                    Text
                    ( λ(d : Text) →
                        ''
                        dhall --file ${d}
                        ''
                    )
                    dhalls
          }

let checkDhallYaml =
      λ(dhalls : List Text) →
        haskellCi.BuildStep.Name
          { name = "Check Dhall can be converted to YAML"
          , run =
                  ''
                  export PATH=$HOME/.cabal/bin:$PATH
                  ''
              ++  Prelude.Text.concatMap
                    Text
                    ( λ(d : Text) →
                        ''
                        dhall-to-yaml-ng --file ${d}
                        ''
                    )
                    dhalls
          }

let dhallSteps =
      λ(steps : List haskellCi.BuildStep) →
            haskellCi.generalCi
              ( haskellCi.Steps::{ buildStep = dhallInstall }
                with extraSteps.post = steps
              )
              haskellCi.DhallMatrix.default
          ⫽ { name = "Dhall CI" }
        : haskellCi.CI.Type

let dhallCi =
      λ(dhalls : List Text) →
        dhallSteps [ checkDhall dhalls ] : haskellCi.CI.Type

in  { dhallInstall
    , dhallYamlInstall
    , dhallCi
    , checkDhall
    , checkDhallYaml
    , dhallSteps
    , CI = haskellCi.CI.Type
    , BuildStep = haskellCi.BuildStep
    , Event = haskellCi.Event
    }
