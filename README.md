# purplpkg
Package manager for Vector

## .ppkg structure
Packages are .tar.gz files with a .ppkg extension. 

Package structure should be similar to:

```
fastfetch.ppkg
    /fastfetch
    /fastfetch-bin
(end of fastfetch.ppkg)
```

fastfetch being a runner script for fastfetch-bin so that colors and ascii art are correct. If your binary can run stanalone this is not necessary.

## Versioning
Just make a file titled your package name and .version for the extension. The version number can be whatever just make it make sense.

Example:

```
file fastfetch.version contains: 1.0.0
```

## File tracking
Make a file with your package name and .flist for the extension.<br>
This file should contain every file that is in the .ppkg file.

```
fastfetch.flist contains:

fastfetch
fastfetch-bin
```

## Todo
- Make the Go version functionally identical to the Bash version
## Goals
- Merge into WireOS (obtained)
- Make it good idk
