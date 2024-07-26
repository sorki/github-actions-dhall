let Prelude =
      https://prelude.dhall-lang.org/v22.0.0/package.dhall
        sha256:1c7622fdc868fe3a23462df3e6f533e50fdc12ecf3b42c0bb45c328ec8c4293e

let Triggers = ./triggers.dhall

let GHC =
      < GHC7103
      | GHC802
      | GHC822
      | GHC844
      | GHC865
      | GHC883
      | GHC884
      | GHC8101
      | GHC8102
      | GHC8103
      | GHC8104
      | GHC8105
      | GHC8106
      | GHC8107
      | GHC901
      | GHC902
      | GHC921
      | GHC922
      | GHC923
      | GHC924
      | GHC925
      | GHC926
      | GHC927
      | GHC928
      | GHC941
      | GHC942
      | GHC943
      | GHC944
      | GHC945
      | GHC946
      | GHC947
      | GHC948
      | GHC961
      | GHC962
      | GHC963
      | GHC964
      | GHC965
      | GHC966
      | GHC981
      | GHC982
      | GHC9101
      >

let printGhc =
      λ(ghc : GHC) →
        merge
          { GHC7103 = "7.10.3"
          , GHC802 = "8.0.2"
          , GHC822 = "8.2.2"
          , GHC844 = "8.4.4"
          , GHC865 = "8.6.5"
          , GHC883 = "8.8.3"
          , GHC884 = "8.8.4"
          , GHC8101 = "8.10.1"
          , GHC8102 = "8.10.2"
          , GHC8103 = "8.10.3"
          , GHC8104 = "8.10.4"
          , GHC8105 = "8.10.5"
          , GHC8106 = "8.10.6"
          , GHC8107 = "8.10.7"
          , GHC901 = "9.0.1"
          , GHC902 = "9.0.2"
          , GHC921 = "9.2.1"
          , GHC922 = "9.2.2"
          , GHC923 = "9.2.3"
          , GHC924 = "9.2.4"
          , GHC925 = "9.2.5"
          , GHC926 = "9.2.6"
          , GHC927 = "9.2.7"
          , GHC928 = "9.2.8"
          , GHC941 = "9.4.1"
          , GHC942 = "9.4.2"
          , GHC943 = "9.4.3"
          , GHC944 = "9.4.4"
          , GHC945 = "9.4.5"
          , GHC946 = "9.4.6"
          , GHC947 = "9.4.7"
          , GHC948 = "9.4.8"
          , GHC961 = "9.6.1"
          , GHC962 = "9.6.2"
          , GHC963 = "9.6.3"
          , GHC964 = "9.6.4"
          , GHC965 = "9.6.5"
          , GHC966 = "9.6.6"
          , GHC981 = "9.8.1"
          , GHC982 = "9.8.2"
          , GHC9101 = "9.10.1"
          }
          ghc

let Cabal =
      < Cabal312
      | Cabal310
      | Cabal38
      | Cabal36
      | Cabal34
      | Cabal32
      | Cabal30
      | Cabal24
      | Cabal22
      | Cabal20
      >

let printCabal =
      λ(cabal : Cabal) →
        merge
          { Cabal312 = "3.12"
          , Cabal310 = "3.10"
          , Cabal38 = "3.8"
          , Cabal36 = "3.6"
          , Cabal34 = "3.4"
          , Cabal32 = "3.2"
          , Cabal30 = "3.0"
          , Cabal24 = "2.4"
          , Cabal22 = "2.2"
          , Cabal20 = "2.0"
          }
          cabal

let OS =
      < Ubuntu
      | Ubuntu2204
      | Ubuntu2004
      | Ubuntu1804
      | Ubuntu1604
      | MacOS
      | Windows
      >

let printOS =
      λ(os : OS) →
        merge
          { Windows = "windows-latest"
          , Ubuntu = "ubuntu-latest"
          , Ubuntu2204 = "ubuntu-22.04"
          , Ubuntu2004 = "ubuntu-20.04"
          , Ubuntu1804 = "ubuntu-18.04"
          , Ubuntu1604 = "ubuntu-16.04"
          , MacOS = "macos-latest"
          }
          os

let defaultGHC = GHC.GHC982

let latestGHC = GHC.GHC9101

let latestCabal = Cabal.Cabal312

let defaultGHC3 = [ defaultGHC, GHC.GHC966, GHC.GHC948 ]

let VersionInfo =
      { Type = { ghc-version : Optional Text, cabal-version : Optional Text }
      , default =
        { ghc-version = Some (printGhc defaultGHC)
        , cabal-version = Some (printCabal latestCabal)
        }
      }

let CacheCfg =
      { Type = { path : Text, key : Text, restoreKeys : Optional Text }
      , default.restoreKeys = None Text
      }

let BuildStep =
      < Uses :
          { uses : Text
          , id : Optional Text
          , `with` : Optional (Prelude.Map.Type Text Text)
          }
      | UsesHaskellSetup :
          { uses : Text
          , id : Optional Text
          , `with` : Optional VersionInfo.Type
          }
      | Name : { name : Text, run : Text }
      | NameIf : { name : Text, run : Text, `if` : Text }
      | UseCache : { uses : Text, `with` : CacheCfg.Type }
      | AwsEnv :
          { name : Text
          , run : Text
          , env : { AWS_ACCESS_KEY_ID : Text, AWS_SECRET_ACCESS_KEY : Text }
          }
      >

let DhallVersion = { ghc-version : GHC, cabal-version : Cabal }

let Matrix = { matrix : { ghc : List Text, cabal : List Text, os : List Text } }

let DhallMatrix =
      { Type = { ghc : List GHC, cabal : List Cabal, os : List OS }
      , default =
        { ghc = [ defaultGHC ], cabal = [ latestCabal ], os = [ OS.Ubuntu ] }
      }

let Build =
      { Type =
          { runs-on : Text
          , name : Text
          , steps : List BuildStep
          , strategy : Matrix
          }
      , default =
        { runs-on = "\${{ matrix.os }}"
        , name =
            "GHC \${{ matrix.ghc }}, Cabal \${{ matrix.cabal }}, OS \${{ matrix.os }}"
        , steps = [] : List BuildStep
        }
      }

let CI =
      { Type =
          { name : Text
          , on : Triggers.Event.Type
          , jobs : { build : Build.Type }
          }
      , default =
        { name = "Haskell CI"
        , on = Triggers.Event.default
        , jobs.build = Build.default
        }
      }

let printEnv =
      λ(v : DhallVersion) →
        VersionInfo::{
        , ghc-version = Some (printGhc v.ghc-version)
        , cabal-version = Some (printCabal v.cabal-version)
        }

let printMatrix =
      λ(v : DhallMatrix.Type) →
        { ghc = Prelude.List.map GHC Text printGhc v.ghc
        , cabal = Prelude.List.map Cabal Text printCabal v.cabal
        , os = Prelude.List.map OS Text printOS v.os
        }

let cache =
      BuildStep.UseCache
        { uses = "actions/cache@v4"
        , `with` =
          { path =
              ''
              ''${{ steps.setup-haskell-cabal.outputs.cabal-store }}
              dist-newstyle
              ''
          , key =
              "\${{ matrix.os }}-\${{ matrix.ghc }}-\${{ matrix.cabal}}-\${{ hashFiles('cabal.project.freeze') }}"
          , restoreKeys = None Text
          }
        }

let checkout =
      BuildStep.Uses
        { uses = "actions/checkout@v4"
        , id = None Text
        , `with` =
              Some [ Prelude.Map.keyText "submodules" "recursive" ]
            : Optional (Prelude.Map.Type Text Text)
        }

let haskellEnv =
      λ(v : VersionInfo.Type) →
        BuildStep.UsesHaskellSetup
          { uses = "haskell-actions/setup@v2"
          , id = Some "setup-haskell-cabal"
          , `with` = Some v
          }

let defaultEnv =
      printEnv { ghc-version = defaultGHC, cabal-version = latestCabal }

let latestEnv =
      printEnv { ghc-version = latestGHC, cabal-version = latestCabal }

let matrixEnv =
      VersionInfo::{
      , ghc-version = Some "\${{ matrix.ghc }}"
      , cabal-version = Some "\${{ matrix.cabal }}"
      }

let mkMatrix = λ(st : DhallMatrix.Type) → { matrix = printMatrix st } : Matrix

let cabalUpdate =
      BuildStep.Name
        { name = "Update Hackage repository", run = "cabal update" }

let cabalProjectFile =
      BuildStep.Name
        { name = "cabal.project.local.ci"
        , run =
            ''
            if [ -e cabal.project.local.ci ]; then
              cp cabal.project.local.ci cabal.project.local
            fi
            ''
        }

let cabalFreeze =
      BuildStep.Name
        { name = "freeze"
        , run = "cabal freeze --enable-tests --enable-benchmarks"
        }

let cabalDeps =
      BuildStep.Name
        { name = "Install dependencies"
        , run =
            "cabal build all --enable-tests --enable-benchmarks --only-dependencies"
        }

let cmdWithFlags =
      λ(cmd : Text) →
      λ(subcommand : Text) →
      λ(flags : List Text) →
        let flagStr =
              if    Prelude.List.null Text flags
              then  ""
              else  " " ++ Prelude.Text.concatSep " " flags

        in  BuildStep.Name
              { name = subcommand, run = "${cmd} ${subcommand}${flagStr}" }

let cabalWithFlags = cmdWithFlags "cabal"

let cabalBuildWithFlags = cabalWithFlags "build all"

let cabalBuild = cabalBuildWithFlags [ "--enable-tests", "--enable-benchmarks" ]

let cabalTest = cabalWithFlags "test all" ([ "--enable-tests" ] : List Text)

let cabalTestProfiling = cabalWithFlags "test all" [ "--enable-profiling" ]

let cabalTestCoverage = cabalWithFlags "test all" [ "--enable-coverage" ]

let cabalDoc = cabalWithFlags "haddock all" ([] : List Text)

let ExtraSteps =
      { Type =
          { pre : List BuildStep
          , postCheckout : List BuildStep
          , post : List BuildStep
          }
      , default =
        { pre = [] : List BuildStep
        , postCheckout = [] : List BuildStep
        , post = [] : List BuildStep
        }
      }

let Steps =
      { Type =
          { checkoutStep : BuildStep
          , haskellEnvStep : BuildStep
          , cabalUpdateStep : BuildStep
          , cabalProjectFileStep : Optional BuildStep
          , cabalFreezeStep : Optional BuildStep
          , cacheStep : BuildStep
          , cabalDepsStep : Optional BuildStep
          , buildStep : BuildStep
          , testStep : Optional BuildStep
          , docStep : Optional BuildStep
          , extraSteps : ExtraSteps.Type
          }
      , default =
        { checkoutStep = checkout
        , haskellEnvStep = haskellEnv matrixEnv
        , cabalUpdateStep = cabalUpdate
        , cabalProjectFileStep = None BuildStep
        , cabalFreezeStep = None BuildStep
        , cacheStep = cache
        , cabalDepsStep = None BuildStep
        , buildStep = cabalBuild
        , testStep = None BuildStep
        , docStep = None BuildStep
        , extraSteps = ExtraSteps.default
        }
      }

let defaultCabalSteps =
      Steps::{
      , cabalProjectFileStep = Some cabalProjectFile
      , cabalFreezeStep = Some cabalFreeze
      , cabalDepsStep = Some cabalDeps
      , testStep = Some cabalTest
      , docStep = Some cabalDoc
      }

let stepsToList =
      λ(steps : Steps.Type) →
            steps.extraSteps.pre
          # [ steps.checkoutStep ]
          # steps.extraSteps.postCheckout
          # Prelude.List.unpackOptionals
              BuildStep
              [ Some steps.haskellEnvStep
              , Some steps.cabalUpdateStep
              , steps.cabalProjectFileStep
              , steps.cabalFreezeStep
              , Some steps.cacheStep
              , steps.cabalDepsStep
              , Some steps.buildStep
              , steps.testStep
              , steps.docStep
              ]
          # steps.extraSteps.post
        : List BuildStep

let generalCi =
      λ(sts : Steps.Type) →
      λ(mat : DhallMatrix.Type) →
          CI::{
          , jobs.build
            = Build::{ steps = stepsToList sts, strategy = mkMatrix mat }
          }
        : CI.Type

let generalCi1 = λ(sts : Steps.Type) → generalCi sts DhallMatrix.default

let defaultCi = generalCi1 defaultCabalSteps : CI.Type

let defaultCi3 =
      generalCi defaultCabalSteps DhallMatrix::{ ghc = defaultGHC3 } : CI.Type

let installNixActionStep =
      BuildStep.Uses
        { uses = "cachix/install-nix-action@v27"
        , id = None Text
        , `with` =
              Some
                [ Prelude.Map.keyText
                    "nix_path"
                    "nixpkgs=channel:nixos-unstable"
                ]
            : Optional (Prelude.Map.Type Text Text)
        }

let installCachixStep =
      λ(accountName : Text) →
        BuildStep.Uses
          { uses = "cachix/cachix-action@v15"
          , id = None Text
          , `with` =
                Some
                  [ Prelude.Map.keyText "name" accountName
                  , Prelude.Map.keyText
                      "signingKey"
                      "\${{ secrets.CACHIX_SIGNING_KEY }}"
                  ]
              : Optional (Prelude.Map.Type Text Text)
          }

let nixBuildStep =
      BuildStep.Name
        { name = "Build with Nix"
        , run =
            "nix-build --argstr compiler \$(echo ghc\${{ matrix.ghc }} | tr -d '.')"
        }

let withNix =
      λ(steps : Steps.Type) →
        steps
        with extraSteps.pre = [ installNixActionStep ] # steps.extraSteps.pre
        with extraSteps.post = steps.extraSteps.post # [ nixBuildStep ]

let hlintStep =
      BuildStep.Name
        { name = "Install and run hlint (optional)"
        , run =
            ''
                cabal install hlint
                hlint -g --no-exit-code
            ''
        }

let hlintRequiredStep =
      BuildStep.Name
        { name = "Install and run hlint"
        , run =
            ''
                cabal install hlint
                hlint -g
            ''
        }

let withHlint =
      λ(steps : Steps.Type) →
        steps
        with extraSteps.post = steps.extraSteps.post # [ hlintStep ]

in  { VersionInfo
    , Build
    , BuildStep
    , Steps
    , ExtraSteps
    , Matrix
    , CI
    , GHC
    , Cabal
    , DhallVersion
    , DhallMatrix
    , CacheCfg
    , OS
    , Event = Triggers.Event
    , Push = Triggers.Push
    , PullRequest = Triggers.PullRequest
    , Cron = Triggers.Cron
    , cabalDoc
    , cabalTest
    , cabalDeps
    , cabalBuild
    , cabalWithFlags
    , cabalBuildWithFlags
    , cabalTestProfiling
    , cabalTestCoverage
    , checkout
    , haskellEnv
    , defaultEnv
    , latestEnv
    , defaultGHC
    , defaultGHC3
    , latestGHC
    , latestCabal
    , matrixEnv
    , defaultCi
    , defaultCi3
    , generalCi
    , generalCi1
    , mkMatrix
    , printMatrix
    , printEnv
    , printGhc
    , printCabal
    , printOS
    , defaultCabalSteps
    , cache
    , installCachixStep
    , installNixActionStep
    , nixBuildStep
    , withNix
    , hlintStep
    , hlintRequiredStep
    , withHlint
    }
