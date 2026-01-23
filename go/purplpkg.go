package main

import (
	"fmt"
	"os"
	"os/exec"
	//"archive/tar"
)

//import "strings"

func main() {
	os.Chdir("/data/purplpkg")
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
		if len(os.Args) < 3 {
			fmt.Println("Usage: purplpkg install <package>")
			os.Exit(1)
		}
		pName := os.Args[2]
		pVersion := exec.Command("curl", ""+mirrorMain+"/"+pName+".version")
		url := mirrorMain + pName + ".tar.gz"
		fmt.Println("Installing package", pName, "with version", pVersion)
		download := exec.Command("curl", "-o", "/data/purplpkg/"+pName+".tar.gz", url)
		download.Run()
		unzip := exec.Command("gunzip", "/data/purplpkg/"+pName+".tar.gz")
		unzip.Run()
		install := exec.Command("tar", "-xvf", "/data/purplpkg/"+pName+".tar", "-C", "/data/purplpkg")
		install.Run()
		clean := exec.Command("rm", ""+pName+".tar.gz", ""+pName+".tar")
		clean.Run()
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
