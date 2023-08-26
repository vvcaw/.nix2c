#!/bin/sh
pushd ~/.nix2c
home-manager switch -f ./users/vvcaw/home.nix
popd
