# env

Extension to handle operations with environment variables

## configure

Reacts on stack definition files when it have a parameter directive `fromEnv`; It will check
if this varible has been defined and add it to the .env file. If not, then it will ask user or
assign a default value (currently only random supported)

## dotenv

Dotenv parser written in bash

Initialy has been inspired by https://github.com/bashup/dotenv however during development this script has been evolved into independent implementation. 

Rationale, we want to be shell compatible (WIP), so we cannot rely on bash substitution, advanced regex and other goodies like arrays.

We have also added possibility to merge multiple `.env` files into a single one

## copy

Provides copy files with backup option
