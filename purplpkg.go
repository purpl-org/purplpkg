package main

import "fmt"
import "strings"
import "os"
import "os/exec"

func main() {
  mirrorMain := "https://www.froggitti.net/vector-mirror/"
  mirrorSecondary := "https://net-3.froggitti.net/vector-mirror/"
  fmt.Println(mirrorMain)
  fmt.Println(mirrorSecondary)

if len(os.Args) < 2 {
    fmt.Println("purplpkg by purpl")
    fmt.Println("-------------------")
    fmt.Println("Usage:")
    fmt.Println("install: Installs a package")
    fmt.Println("package-list: Lists currently available packages")
    os.Exit(1)
}
  
}
