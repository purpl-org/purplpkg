# purplpkg
Bash package manager for purplOS

## Anki folder handling
Your .tar for the /anki folder should be formatted as such<br>
I will use anki-purplOS.tar as an example
```
anki-purplOS.tar
- anki/
```
anki-purplOS.tar is then compressed with gzip to become anki-purplOS.tar.gz<br>
The package manager expects this exact format, so if your structure differs it will not install correctly.
