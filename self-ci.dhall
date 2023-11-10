let dhallCi = ./dhall-ci.dhall

in    dhallCi.dhallSteps
        [ dhallCi.dhallYamlInstall
        , dhallCi.checkDhall [ "haskell-ci.dhall", "self-ci.dhall" ]
        , dhallCi.checkDhallYaml
            [ "self-ci.dhall"
            , "ci.dhall"
            , "example-defaultCi/ci.dhall"
            , "example-defaultCi3/ci.dhall"
            ]
        ]
    : dhallCi.CI
