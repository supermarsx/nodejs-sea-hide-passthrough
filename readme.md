# nodejs-sea-hide-passthrough

![GitHub stars](https://img.shields.io/github/stars/supermarsx/nodejs-sea-hide-passthrough?style=social)
![GitHub forks](https://img.shields.io/github/forks/supermarsx/nodejs-sea-hide-passthrough?style=social)
![GitHub watchers](https://img.shields.io/github/watchers/supermarsx/nodejs-sea-hide-passthrough?style=social)
![GitHub issues](https://img.shields.io/github/issues/supermarsx/nodejs-sea-hide-passthrough)
[![CI](https://github.com/supermarsx/nodejs-sea-hide-passthrough/actions/workflows/ci.yml/badge.svg)](https://github.com/supermarsx/nodejs-sea-hide-passthrough/actions/workflows/ci.yml)

This a simple binary passthrough that hides the console window when a SEA (Single Executable Application) is opened. Useful when you want a simple nodejs SEA to run on the background and don't show any console windows. It also passes along every console argument through.

## Usage
1. Install AutoIt3
2. Edit `nodejs-sea-hide-passthrough.au3` and replace `NAME_OF_YOUR_BINARY` with your SEA name
3. Build the `au3` file
4. Place it next to the SEA 
5. Execute

## Creating a Node.js Single Executable Application (SEA)

If you haven't created a Node.js SEA yet, here is a quick guide based on the [official Node.js documentation](https://nodejs.org/api/single-executable-applications.html).

### 1. Preparation
Create your JavaScript file (e.g., `hello.js`) and a configuration file `sea-config.json`:

**hello.js**
```javascript
console.log(`Hello, ${process.argv[2]}!`);
```

**sea-config.json**
```json
{
  "main": "hello.js",
  "output": "sea-prep.blob"
}
```

### 2. Generate the Blob
Run the following command to generate the `sea-prep.blob`:

```bash
node --experimental-sea-config sea-config.json
```

### 3. Create the Executable
Copy the node executable to your project folder.

**Windows (PowerShell):**
```powershell
node -e "require('fs').copyFileSync(process.execPath, 'hello.exe')"
```

**Linux/macOS:**
```bash
cp $(command -v node) hello
```

### 4. Inject the Blob
Use `postject` to inject the blob into the executable.

```bash
npx postject hello.exe NODE_SEA_BLOB sea-prep.blob --sentinel-fuse NODE_SEA_FUSE_fce680ab2cc467b6e072b8b5df1996b2
```
*(On macOS, add `--macho-segment-name NODE_SEA`)*

Now you have a standalone `hello.exe`! You can use this `nodejs-sea-hide-passthrough` tool to wrap it and hide the console window.

## License
Distributed under MIT License. See `license.md` for more information.