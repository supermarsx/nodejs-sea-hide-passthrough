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

## License
Distributed under MIT License. See `license.md` for more information.