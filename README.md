# purplpkg
Bash/Go package manager for Vector

# Go port currently in development
## Package handling
The way the package manager installs packages is by downloading the tar.gz, uncompressing and extracting it to the root of /data/purplpkg..<br>

Package structure should be as such<br>
I will use update as an example
```
update.flist
update.version
update.ppkg
 / update
```
update being the file that goes into /data/purplpkg.
## Todo
- Version checking for packages (done in the Bash version just need to do for the Go version)
- Remove function
## Goals
- Start a public FTP server for all to upload packages
- Make it good idk
