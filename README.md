# purplpkg
Bash/Go package manager for Vector

## Go port currently in development

## Anki folder handling
Your .tar for the /anki folder should be formatted as such<br>
I will use anki-purplOS.tar as an example
```
anki-purplOS.tar
- anki/
  - bin
  - data
  - etc
  - lib
```
anki-purplOS.tar is then compressed with gzip to become anki-purplOS.tar.gz<br>
The package manager expects this exact format, so if your structure differs it will not install correctly.
## Actual package handling
The way the package manager installs packages is by downloading the tar.gz, uncompressing it then making its own directory for the actual package in /data/purplpkg.<br>

Package structure should be as such<br>
I will use update-purplOS.tar as an example
```
update-purplOS.tar
- update.sh
```
update.sh being the file that goes into /sbin.
## Todo
- Version checking for packages
- Remove function
## Goals
- Start a public FTP server for all to upload packages
- Make it good idk
