let Prelude =
      https://prelude.dhall-lang.org/v22.0.0/package.dhall
        sha256:1c7622fdc868fe3a23462df3e6f533e50fdc12ecf3b42c0bb45c328ec8c4293e

-- See https://github.com/haskell-actions/setup/blob/main/src/versions.json
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
      | GHC961
      | GHC962
      | GHC963
      | GHC981
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
          , GHC961 = "9.6.1"
          , GHC962 = "9.6.2"
          , GHC963 = "9.6.3"
          , GHC981 = "9.8.1"
          }
          ghc

let Cabal =
      < Cabal310
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
          { Cabal310 = "3.10"
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

let defaultGHC = GHC.GHC963

let latestGHC = GHC.GHC981

let latestCabal = Cabal.Cabal310

let defaultGHC3 = [ defaultGHC, GHC.GHC947, GHC.GHC928 ]

let VersionInfo =
      { Type =
          { ghc-version : Optional Text
          , cabal-version : Optional Text
          , stack-version : Optional Text
          , enable-stack : Optional Bool
          , stack-no-global : Optional Bool
          , stack-setup-ghc : Optional Bool
          }
      , default =
        { ghc-version = Some (printGhc defaultGHC)
        , cabal-version = Some "3.10"
        , stack-version = None Text
        , enable-stack = Some False
        , stack-no-global = None Bool
        , stack-setup-ghc = None Bool
        }
      }

let PyInfo = { python-version : Text, architecture : Optional Text }

let CacheCfg =
      { Type = { path : Text, key : Text, restoreKeys : Optional Text }
      , default.restoreKeys = None Text
      }

let BuildStep =
      < Uses :
          { uses : Text
          , id : Optional Text
          , `with` : Optional VersionInfo.Type
          }
      | Name : { name : Text, run : Text }
      | UseCache : { uses : Text, `with` : CacheCfg.Type }
      | UsePy : { uses : Text, `with` : PyInfo }
      | AwsEnv :
          { name : Text
          , run : Text
          , env : { AWS_ACCESS_KEY_ID : Text, AWS_SECRET_ACCESS_KEY : Text }
          }
      >

let DhallVersion = { ghc-version : GHC, cabal-version : Cabal }

let Matrix = { matrix : { ghc : List Text, cabal : List Text } }

let DhallMatrix =
      { Type = { ghc : List GHC, cabal : List Cabal }
      , default = { ghc = [ defaultGHC ], cabal = [ latestCabal ] }
      }

let Event = < push | release | pull_request >

let CI =
      { Type =
          { name : Text
          , on : List Event
          , jobs :
              { build :
                  { runs-on : Text
                  , steps : List BuildStep
                  , strategy : Optional Matrix
                  }
              }
          }
      , default =
        { name = "Haskell CI", on = [ Event.push, Event.pull_request ] }
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
        }

let cache =
      BuildStep.UseCache
        { uses = "actions/cache@v3"
        , `with` =
          { path =
              ''
              ''${{ steps.setup-haskell-cabal.outputs.cabal-store }}
              dist-newstyle
              ''
          , key =
              "\${{ runner.os }}-\${{ matrix.ghc }}-cabal-\${{ hashFiles('cabal.project.freeze') }}"
          , restoreKeys = None Text
          }
        }

let stackCache =
      BuildStep.UseCache
        { uses = "actions/cache@v3"
        , `with` =
          { path = "~/.stack"
          , key = "\${{ runner.os }}-\${{ matrix.ghc }}-stack"
          , restoreKeys = None Text
          }
        }

let checkout =
      BuildStep.Uses
        { uses = "actions/checkout@v4"
        , id = None Text
        , `with` = None VersionInfo.Type
        }

let haskellEnv =
      λ(v : VersionInfo.Type) →
        BuildStep.Uses
          { uses = "haskell-actions/setup@v2"
          , id = Some "setup-haskell-cabal"
          , `with` = Some v
          }

let defaultEnv =
      printEnv { ghc-version = defaultGHC, cabal-version = latestCabal }

let latestEnv =
      printEnv { ghc-version = latestGHC, cabal-version = latestCabal }

let matrixOS = "\${{ matrix.operating-system }}"

let matrixEnv =
      VersionInfo::{
      , ghc-version = Some "\${{ matrix.ghc }}"
      , cabal-version = Some "\${{ matrix.cabal }}"
      }

let stackEnv =
        { ghc-version = Some (printGhc defaultGHC)
        , cabal-version = None Text
        , stack-version = Some "latest"
        , enable-stack = Some True
        , stack-no-global = Some True
        , stack-setup-ghc = None Bool
        }
      : VersionInfo.Type

let mkMatrix = λ(st : DhallMatrix.Type) → { matrix = printMatrix st } : Matrix

let cabalUpdate =
      BuildStep.Name
        { name = "Update Hackage repository", run = "cabal update" }

-- use this eg. if you want to set specific flags or options like
-- `-Werror` only on ci, not in the local dev environment.
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

let installNixActionStep =
      BuildStep.Uses
        { uses = "cachix/install-nix-action@v23"
        , id = None Text
        , `with` = None VersionInfo.Type
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

let stackWithFlags = cmdWithFlags "stack"

let stackBuildWithFlags = stackWithFlags "build"

let stackBuild =
      stackBuildWithFlags
        [ "--bench", "--test", "--no-run-tests", "--no-run-benchmarks" ]

let cabalTest = cabalWithFlags "test all" ([ "--enable-tests" ] : List Text)

let stackTest = stackWithFlags "test" ([] : List Text)

let cabalTestProfiling = cabalWithFlags "test all" [ "--enable-profiling" ]

let cabalTestCoverage = cabalWithFlags "test all" [ "--enable-coverage" ]

let cabalDoc = cabalWithFlags "haddock" ([] : List Text)

let Steps =
      { Type =
          { extraStepsPre : List BuildStep
          , checkoutStep : BuildStep
          , haskellEnvStep : BuildStep
          , cabalUpdateStep : BuildStep
          , cabalProjectFileStep : Optional BuildStep
          , cabalFreezeStep : Optional BuildStep
          , cacheStep : BuildStep
          , cabalDepsStep : Optional BuildStep
          , buildStep : BuildStep
          , testStep : Optional BuildStep
          , docStep : Optional BuildStep
          , extraSteps : List BuildStep
          }
      , default =
        { extraStepsPre = [] : List BuildStep
        , checkoutStep = checkout
        , haskellEnvStep = haskellEnv defaultEnv
        , cabalUpdateStep = cabalUpdate
        , cabalProjectFileStep = None BuildStep
        , cabalFreezeStep = None BuildStep
        , cacheStep = cache
        , cabalDepsStep = None BuildStep
        , buildStep = cabalBuild
        , testStep = None BuildStep
        , docStep = None BuildStep
        , extraSteps = [] : List BuildStep
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

let defaultStackSteps =
      Steps::{
      , cacheStep = stackCache
      , buildStep = stackBuild
      , testStep = Some stackTest
      }

let stepsToList =
      λ(steps : Steps.Type) →
            steps.extraStepsPre
          # Prelude.List.filterMap
              (Optional BuildStep)
              BuildStep
              (λ(optStep : Optional BuildStep) → optStep)
              [ Some steps.checkoutStep
              , Some steps.haskellEnvStep
              , Some steps.cabalUpdateStep
              , steps.cabalProjectFileStep
              , steps.cabalFreezeStep
              , Some steps.cacheStep
              , steps.cabalDepsStep
              , Some steps.buildStep
              , steps.testStep
              , steps.docStep
              ]
          # steps.extraSteps
        : List BuildStep

let matrixSteps =
        (defaultCabalSteps with haskellEnvStep = haskellEnv matrixEnv)
      : Steps.Type

let generalCi =
      λ(sts : Steps.Type) →
      λ(mat : Optional DhallMatrix.Type) →
          CI::{
          , jobs.build
            =
            { runs-on = printOS OS.Ubuntu
            , steps = stepsToList sts
            , strategy =
                Prelude.Optional.map DhallMatrix.Type Matrix mkMatrix mat
            }
          }
        : CI.Type

let ciNoMatrix = λ(sts : Steps.Type) → generalCi sts (None DhallMatrix.Type)

let stackSteps =
        [ checkout, haskellEnv stackEnv, stackCache, stackBuild, stackTest ]
      : List BuildStep

let defaultCi = generalCi defaultCabalSteps (None DhallMatrix.Type) : CI.Type

let defaultCi3 = generalCi matrixSteps (Some { ghc = defaultGHC3, cabal = [ latestCabal ]}) : CI.Type

in  { VersionInfo
    , BuildStep
    , Steps
    , Matrix
    , CI
    , GHC
    , Cabal
    , DhallVersion
    , DhallMatrix
    , CacheCfg
    , OS
    , PyInfo
    , Event
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
    , mkMatrix
    , printMatrix
    , printEnv
    , printGhc
    , printCabal
    , printOS
    , matrixOS
    , defaultCabalSteps
    , defaultStackSteps
    , matrixSteps
    , ciNoMatrix
    , cache
    , stackEnv
    , stackWithFlags
    , stackSteps
    , stackBuild
    , stackTest
    , stackCache
    , installNixActionStep
    }
