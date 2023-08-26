#!/bin/sh
pushd ~/.nix2c
nix build .#homeManagerConfigurations.vvcaw.activationPackage
./result/activate
popd
