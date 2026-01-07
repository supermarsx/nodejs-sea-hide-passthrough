# nodejs-sea-hide-passthrough

![GitHub release (latest by date)](https://img.shields.io/github/v/release/supermarsx/nodejs-sea-hide-passthrough?style=flat-square)
![GitHub downloads](https://img.shields.io/github/downloads/supermarsx/nodejs-sea-hide-passthrough/total?style=flat-square)
![GitHub stars](https://img.shields.io/github/stars/supermarsx/nodejs-sea-hide-passthrough?style=flat-square)
![GitHub forks](https://img.shields.io/github/forks/supermarsx/nodejs-sea-hide-passthrough?style=flat-square)
![GitHub watchers](https://img.shields.io/github/watchers/supermarsx/nodejs-sea-hide-passthrough?style=flat-square)
![GitHub issues](https://img.shields.io/github/issues/supermarsx/nodejs-sea-hide-passthrough?style=flat-square)
[![CI](https://github.com/supermarsx/nodejs-sea-hide-passthrough/actions/workflows/ci.yml/badge.svg?style=flat-square)](https://github.com/supermarsx/nodejs-sea-hide-passthrough/actions/workflows/ci.yml)

This a simple binary passthrough that hides the console window when a SEA (Single Executable Application) is opened. Useful when you want a simple nodejs SEA to run on the background and don't show any console windows. It also passes along every console argument through.

## Usage
1. Download the latest release (`nodejs-sea-hide-passthrough.exe` and `config.ini`).
2. Place both files in the same directory as your Node.js SEA (or any other executable you want to hide).
3. Edit `config.ini` and set `Target=YOUR_APP_NAME.exe`.
4. Run `nodejs-sea-hide-passthrough.exe`. It will launch your app in a hidden window and pass all arguments to it.

## Configuration (config.ini)
The behavior is controlled by `config.ini`:
```ini
[Settings]
; The name of the Single Executable Application (SEA) or binary to launch.
Target=helo.exe
```

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