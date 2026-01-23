package main

import (
	"fmt"
	"os"
	"os/exec"
)

func main() {
	os.Chdir("/data/purplpkg")
	mirrorMain := "https://www.froggitti.net/vector-mirror/"

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
		url := mirrorMain + pName + ".tar.gz"
		version := mirrorMain + pName + ".version"
		fmt.Println("Installing package", pName)
		versioning := exec.Command("curl", "-o", "/data/purplpkg/versions/"+pName+"", version)
		versioning.Run()
		fmt.Println("Version downloaded successfully")
		download := exec.Command("curl", "-o", "/data/purplpkg/"+pName+".tar.gz", url)
		download.Run()
		fmt.Println("Package downloaded")
		unzip := exec.Command("gunzip", "/data/purplpkg/"+pName+".tar.gz")
		unzip.Run()
		fmt.Println("Package decompressed")
		install := exec.Command("tar", "-xvf", "/data/purplpkg/"+pName+".tar", "-C", "/data/purplpkg")
		install.Run()
		fmt.Println("Package installed")
		clean := exec.Command("rm", ""+pName+".tar.gz", ""+pName+".tar")
		clean.Run()
		fmt.Println("Done.")
		os.Exit(0)
	case "mirror-list":
		fmt.Println("Active Mirrors:")
		fmt.Println("-------------------")
		fmt.Println(mirrorMain)
		os.Exit(0)
	case "package-list":
		cmd := exec.Command("curl", "https://www.froggitti.net/vector-mirror/package.list")
		output, _ := cmd.Output()
		fmt.Println(string(output))
		os.Exit(0)
	}
}
