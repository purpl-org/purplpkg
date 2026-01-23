# purplpkg
Bash/Go package manager for Vector

# Go port currently in development
## Package handling
The way the package manager installs packages is by downloading the tar.gz, uncompressing and extracting it to the root of /data/purplpkg..<br>

Package structure should be as such<br>
I will use update.tar as an example
```
/data/purplpkg
 /versions
  update
update.tar
  update
```
update being the file that goes into /data/purplpkg.
## Todo
- Version checking for packages
- Remove function
## Goals
- Start a public FTP server for all to upload packages
- Make it good idk
