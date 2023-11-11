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

Then, generate YAML with `dhall-to-yaml-ng --generated-comment --file example.dhall`, see also [`ci.sh`](./ci.sh)

```yaml
# Code generated by dhall-to-yaml.  DO NOT EDIT.
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

### GHC Versions

If the last released GHC version is for example `GHC981`,
it is aliased to `latestGHC`.
The next major release (in our case `GHC963`) is
aliased to `defaultGHC`.
The `defaultGHC3` is then a list of `defaultGHC` and two major releases
before it - for our example that is `[ defaultGHC, GHC.GHC947, GHC.GHC928 ]`.

This represents a reasonable maintenance policy of supporting three
major releases, not including the `latestGHC` which is typically
in flux until most of the ecosystem ports to it.

### Variants

#### `defaultCi`

This is a simple build using `defaultGHC`, `latestCabal`, `Ubuntu` (which corresponds to `ubuntu-latest`)
and no matrix.
See [example-defaultCi/ci.dhall](./example-defaultCi/ci.dhall)

#### `defaultCi3`

This is a matrix build using `defaultGHC3`.
See [example-defaultCi3/ci.dhall](./example-defaultCi3/ci.dhall)

### Customization

#### `cabal.project.local.ci`

If you want to set specific flags or options like
`-Werror` only on ci and not in the local dev environment,
you can add `cabal.project.local.ci` file which
is copied to `cabal.project.local` during workflow run.

Example contents:
```
flags: +someflag

package somepackage:
  ghc-options:
    -Wunused-packages
    -Wall
```

## Projects that use `github-actions-dhall`

* [data-lens-light](https://github.com/UnkindPartition/data-lens-light)
* [gcodehs](https://github.com/distrap/gcodehs/)
* [Haskell-Nix-Derivation-Library](https://github.com/Gabriella439/Haskell-Nix-Derivation-Library/)
* [haskell-project-template](https://github.com/sorki/haskell-project-template/)
* [ImplicitCAD](https://github.com/Haskell-Things/ImplicitCAD)
* [nix-diff](https://github.com/Gabriella439/nix-diff)
* [nix-narinfo](https://github.com/sorki/nix-narinfo/)
* [ImplicitCAD](https://github.com/Haskell-Things/ImplicitCAD)

## Development

### GHC and Cabal versions

Typically synchronized with an upstream [haskell-actions/setup](https://github.com/haskell-actions/setup/)
from their [versions.json](https://github.com/haskell-actions/setup/blob/main/src/versions.json)
