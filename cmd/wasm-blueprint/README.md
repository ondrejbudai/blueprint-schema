# Blueprint WASM Converter

This package exports the exportTOML functionality from the main blueprint schema tool as WebAssembly functions that can be used in web browsers.

## Features

- Convert YAML blueprint files to TOML format
- Convert YAML blueprint files to JSON format
- Run entirely in the browser with WebAssembly
- No server-side dependencies required

## Building

To build the WASM module, run:

```bash
cd cmd/wasm-blueprint
./build.sh
```

This will generate:
- `blueprint.wasm` - The WebAssembly module
- `wasm_exec.js` - Go's WebAssembly runtime support

## Usage

### Online Demo

The WASM converter is automatically deployed to GitHub Pages and available at:
**https://osbuild.github.io/blueprint-schema/**

This provides a ready-to-use web interface without needing to build or serve anything locally.

### Local Development

1. Build the WASM module as described above
2. Serve the files over HTTP (required for WASM loading)
3. Open `index.html` in your browser

Example using Python's built-in server:
```bash
cd cmd/wasm-blueprint
./build.sh
python3 -m http.server 8000
# Open http://localhost:8000/
```

### JavaScript API

Once the WASM module is loaded, you can use these functions:

```javascript
// Convert YAML to TOML
const result = exportTOML(yamlString);
if (result.error) {
    console.error("Conversion failed:", result.error);
} else {
    console.log("TOML output:", result.toml);
}

// Convert YAML to JSON
const result = exportJSON(yamlString);
if (result.error) {
    console.error("Conversion failed:", result.error);
} else {
    console.log("JSON output:", result.json);
}
```

### Loading the WASM Module

```javascript
const go = new Go();
WebAssembly.instantiateStreaming(fetch("blueprint.wasm"), go.importObject)
    .then((result) => {
        go.run(result.instance);
        // Now you can use exportTOML() and exportJSON()
    });
```

## Example Blueprint

```yaml
name: example-blueprint
description: Example blueprint for testing
version: 1.0.0

packages:
  - name: vim
  - name: git

groups:
  - name: wheel

users:
  - name: admin
    password: "$6$example"
    groups: ["wheel"]
```

## Error Handling

Both functions return objects with either:
- Success: `{toml: "..."` or `{json: "..."}`
- Error: `{error: "error message"}`

Always check for the `error` field in the returned object.

## Requirements

- Go 1.20+ (for building)
- Modern web browser with WebAssembly support
- HTTP server (for serving WASM files)

## Deployment

The WASM converter is automatically deployed to GitHub Pages via GitHub Actions whenever changes are made to:
- The `cmd/wasm-blueprint/` directory
- The `pkg/` directory (shared conversion logic)
- The deployment workflow itself

The deployment workflow:
1. Builds the WASM module using Go
2. Copies the necessary files (`blueprint.wasm`, `wasm_exec.js`, `index.html`)
3. Deploys to GitHub Pages

## Notes

- The WASM module must be served over HTTP/HTTPS (not file://) due to browser security restrictions
- The module uses the same conversion logic as the main blueprint tool
- All processing happens client-side in the browser
- GitHub Pages deployment happens automatically on pushes to the main branch
