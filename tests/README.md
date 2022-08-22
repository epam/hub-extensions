# Tests

Tests is implemented with a help of [bats](https://github.com/bats-core/bats-core)

## Setup

Bats is installed as git submodule. To install it run next command:

```bash
git submodule update --init --recursive
```

This command will install Bats itself, and two helpers: [bats-support](https://github.com/bats-core/bats-support) and [bats-assert](https://github.com/bats-core/bats-assert)

## Run

To run test

```bash
./bats/bin/bats *.bats
```
