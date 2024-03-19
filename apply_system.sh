#!/bin/sh
pushd ~/.nix2c
sudo nixos-rebuild switch --flake .#matryoshka
popd
