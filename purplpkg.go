package main

import "fmt"
//import "strings"
import "os"
import "os/exec"

func main() {
  mirrorMain := "https://www.froggitti.net/vector-mirror/"
  mirrorSecondary := "https://net-3.froggitti.net/vector-mirror/"
//  fmt.Println(mirrorMain)
//  fmt.Println(mirrorSecondary)

if len(os.Args) < 2 {
    fmt.Println("purplpkg by purpl")
    fmt.Println("-------------------")
    fmt.Println("Usage:")
    fmt.Println("install: Installs a package")
    fmt.Println("package-list: Lists currently available packages")
    fmt.Println("mirror-list: Lists currently set mirrors")
    os.Exit(1)
}

  switch os.Args[1] {
    case "install":
     fmt.Println("coming soon idk")
     os.Exit(0)
    case "mirror-list":
     fmt.Println(mirrorMain)
     fmt.Println(mirrorSecondary)
     os.Exit(0)
    case "package-list":
     cmd := exec.Command("curl", "https://www.froggitti.net/vector-mirror/package.list")
     output, _ := cmd.Output()
     fmt.Println(string(output))
     os.Exit(0)
    }
}
