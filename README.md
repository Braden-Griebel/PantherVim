# My NVIM Config Using nixCats

NVIM config based on nixCats (specifically their example template), which
allows for use in both nix and non-nix environments.
In non-nix environments plugins will be installed with paq, and
LSPs/formatters/etc. will be installed with Mason.

# Installation

For nix based installs, the flake can be used as an input, and
comes with a home-manager module.
For non-nix installs, just clone the repo into the desired NVIM
config location, and it should mostly install everything. Some of the
formatters and linters won't be installed automatically with Mason,
specifically:

- clang-format
- shfmt
- mdformat
- typstyle
- alejandra
- markdownlint-cli2
- shellcheck
- oxlint
- eslint
- mypy
