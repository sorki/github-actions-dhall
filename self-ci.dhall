let dhallCi = ./dhall-ci.dhall

in    dhallCi.dhallSteps
        [ dhallCi.dhallYamlInstall
        , dhallCi.checkDhall [ "haskell-ci.dhall", "self-ci.dhall" ]
        , dhallCi.checkDhallYaml
            [ "self-ci.dhall"
            , "ci.dhall"
            , "example-combinators/ci.dhall"
            , "example-defaultCi/ci.dhall"
            , "example-defaultCi3/ci.dhall"
            , "example-extraSteps/ci.dhall"
            , "example-readme/ci.dhall"
            ]
        ]
    : dhallCi.CI
