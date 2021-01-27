#!/bin/bash

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    sh <(curl -L https://nixos.org/nix/install) 
elif [[ "$OSTYPE" == "darwin"* ]]; then
    sh <(curl -L https://nixos.org/nix/install) --darwin-use-unencrypted-nix-store-volume
else
    echo Unsupported Operating System ${OSTYPE}
fi