PHONY: all
shell:
	nix-shell -p dhall dhall-docs dhall-yaml

all:
	dhall --file haskell-ci.dhall > /dev/null
	dhall --file self-ci.dhall > /dev/null
	dhall --file example-defaultCi/ci.dhall > /dev/null
	dhall --file example-defaultCi3/ci.dhall > /dev/null
	dhall --file example-extraSteps/ci.dhall > /dev/null
	dhall --file example-combinators/ci.dhall > /dev/null
	dhall --file example-readme/ci.dhall > /dev/null

	dhall format haskell-ci.dhall
	dhall format dhall-ci.dhall
	dhall format triggers.dhall
	dhall format self-ci.dhall
	dhall format example-defaultCi/ci.dhall
	dhall format example-defaultCi3/ci.dhall
	dhall format example-extraSteps/ci.dhall
	dhall format example-combinators/ci.dhall
	dhall format example-defaultCi3/ci.dhall
	dhall format example-readme/ci.dhall

	.github/workflows/self-ci.sh

docs:
	dhall-docs --input . --output-link docs
