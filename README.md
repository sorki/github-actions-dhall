# github-actions-dhall

Use Dhall to generate YAML for Github Actions for building Haskell projects.

Fork based on https://github.com/vmchale/github-actions-dhall focusing
mainly on `haskell-ci.dhall`.


`github-actions-dhall` is
[self-hosting](https://github.com/sorki/github-actions-dhall/blob/main/self-ci.dhall).

## Example

### Haskell

Store the following in `ci.dhall` (or use the one provided in this repository):

```dhall
let haskellCi = https://raw.githubusercontent.com/sorki/github-actions-dhall/main/haskell-ci.dhall

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
```

Then, generate YAML with `dhall-to-yaml-ng --file example.dhall`, see also [`ci.sh`](./ci.sh)

```yaml
jobs:
  build:
    "runs-on": "ubuntu-latest"
    steps:
    - uses: "actions/checkout@v4"
    - id: "setup-haskell-cabal"
      uses: "haskell-actions/setup@v2"
      with:
        "cabal-version": "${{ matrix.cabal }}"
        "enable-stack": false
        "ghc-version": "${{ matrix.ghc }}"
    - name: Update Hackage repository
      run: cabal update
    - name: cabal.project.local.ci
      run: |
        if [ -e cabal.project.local.ci ]; then
          cp cabal.project.local.ci cabal.project.local
        fi
    - name: freeze
      run: "cabal freeze --enable-tests --enable-benchmarks"
    - uses: "actions/cache@v3"
      with:
        key: "${{ runner.os }}-${{ matrix.ghc }}-cabal-${{ hashFiles('cabal.project.freeze') }}"
        path: |
          ${{ steps.setup-haskell-cabal.outputs.cabal-store }}
          dist-newstyle
    - name: Install dependencies
      run: "cabal build all --enable-tests --enable-benchmarks --only-dependencies"
    - name: build all
      run: "cabal build all --enable-tests --enable-benchmarks"
    - name: test all
      run: "cabal test all --enable-tests"
    - name: haddock
      run: cabal haddock
    strategy:
      matrix:
        cabal:
        - '3.10'
        ghc:
        - '9.6.3'
        - '9.4.7'
        - '9.2.7'
name: Haskell CI
'on':
- push
- pull_request
```
