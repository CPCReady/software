#!/bin/bash

export CPC_DIR="$HOME/.cpc"
export PATH="$CPC_DIR/bin:$PATH"

source "$CPC_DIR/src/cpc-config.sh"
source "$CPC_DIR/src/cpc-main.sh"