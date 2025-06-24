#!/bin/bash

# Build script for WASM blueprint converter

set -e

# Set WASM build environment
export GOOS=js
export GOARCH=wasm

# Build the WASM module
echo "Building WASM module..."
go build -o blueprint.wasm .

# Copy the WASM support JS file from Go installation
# Try the newer location first, then fall back to the older location
if [ -f "$(go env GOROOT)/lib/wasm/wasm_exec.js" ]; then
    cp "$(go env GOROOT)/lib/wasm/wasm_exec.js" .
    echo "Copied wasm_exec.js support file from lib/wasm/"
elif [ -f "$(go env GOROOT)/misc/wasm/wasm_exec.js" ]; then
    cp "$(go env GOROOT)/misc/wasm/wasm_exec.js" .
    echo "Copied wasm_exec.js support file from misc/wasm/"
else
    echo "Warning: wasm_exec.js not found in Go installation"
fi

echo "Build complete!"
echo "Files generated:"
echo "  - blueprint.wasm (WASM module)"
echo "  - wasm_exec.js (Go WASM runtime support)"
