# Windows PowerShell dev scripts (dev/scripts/win)

These helper scripts make it easy to run common dev tasks on Windows (PowerShell) for this AutoIt project: **lint**, **format**, **test**, and **build**.

Usage examples (from the repository root):

- **Run lint (Au3Check)**:
  ```powershell
  .\dev\scripts\win\lint.ps1
  ```
  Runs `Au3Check.exe` on all `.au3` files.

- **Run format (Tidy)**:
  ```powershell
  .\dev\scripts\win\format.ps1
  ```
  Runs `Tidy.exe` (from SciTE) on all `.au3` files.

- **Run tests**:
  ```powershell
  .\dev\scripts\win\test.ps1
  ```
  Searches for generic test files (`*_test.au3`) or runs the main file in syntax check mode as a fallback.

- **Run build (Aut2Exe)**:
  ```powershell
  .\dev\scripts\win\build.ps1
  ```
  Compiles `nodejs-sea-hide-passthrough.au3` to `nodejs-sea-hide-passthrough.exe`.

### Requirements
- **AutoIt3** installed (normally `C:\Program Files (x86)\AutoIt3`).
- **Au3Check**, **Aut2Exe**, and **Tidy** (part of SciTE4AutoIt3) should be available in standard paths or your PATH.
- To run without changing system policy, use `powershell -ExecutionPolicy Bypass -File ...`
