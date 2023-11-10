let haskellCi = ./haskell-ci.dhall

let Prelude =
      https://prelude.dhall-lang.org/v22.0.0/package.dhall
        sha256:1c7622fdc868fe3a23462df3e6f533e50fdc12ecf3b42c0bb45c328ec8c4293e

let dhallInstall =
      haskellCi.BuildStep.Name
        { name = "Install dhall"
        , run =
            ''
            cabal update
            cd "$(mktemp -d /tmp/dhall-XXX)"
            cabal install dhall
            ''
        }

let dhallYamlInstall =
      haskellCi.BuildStep.Name
        { name = "Install dhall-to-yaml &c."
        , run =
            ''
            cabal update
            cd "$(mktemp -d /tmp/dhall-XXX)"
            cabal install dhall-yaml
            ''
        }

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
            haskellCi.ciNoMatrix
              haskellCi.Steps::{ buildStep = dhallInstall , extraSteps = steps }
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
