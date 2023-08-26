#!/bin/sh
pushd ~/.nix2c
sudo nixos-rebuild switch -I nixos-config=./system/configuration.nix
popd
