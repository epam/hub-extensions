# dotenv

Dotenv parser written in bash

Initialy has been inspired by https://github.com/bashup/dotenv however during development this script has been significantly reworked. Rationale, we want to be shell compatible (WIP), so we cannot rely on bash substitution, advanced regex and other goodies like arrays.

We have also added possibility to merge multiple `.env` files into a single one
