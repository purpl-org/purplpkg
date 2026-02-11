package main

import (
	"fmt"
	"os"
	"os/exec"
)

func main() {
	os.Chdir("purplpkg")
	mirrorMain := "https://www.froggitti.net/vector-mirror/"

	if len(os.Args) < 2 {
		fmt.Println("purplpkg by purpl")
		fmt.Println("-------------------")
		fmt.Println("Usage:")
		fmt.Println("install: Installs a package")
		fmt.Println("update: Updates an installed package")
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
		url := mirrorMain + pName + ".ppkg"
		version := mirrorMain + pName + ".version"
		fmt.Println("Installing package", pName)
		versioning := exec.Command("curl", "-o", "purplpkg/versions/"+pName+"", version)
		versioning.Run()
		fmt.Println("Version downloaded successfully")
		download := exec.Command("curl", "-o", "purplpkg/"+pName+".ppkg", url)
		download.Run()
		fmt.Println("Package downloaded")
		unzip := exec.Command("gunzip", "purplpkg/"+pName+".ppkg")
		unzip.Run()
		fmt.Println("Package decompressed")
		install := exec.Command("tar", "-xvf", "purplpkg/"+pName+".tar", "-C", "purplpkg")
		install.Run()
		fmt.Println("Package installed")
		clean := exec.Command("rm", ""+pName+".ppkg", ""+pName+".tar")
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
	case "update":
		if len(os.Args) < 3 {
			fmt.Println("Usage: purplpkg update <package>")
			os.Exit(1)
		}

		pName := os.Args[2]

		curllatestget := exec.Command("curl", mirrorMain+pName+".version")
		curllatestoutput, _ := curllatestget.Output()
		curllatest := string(curllatestoutput)
		//fmt.Println(curllatest)

		curlinstalledget := exec.Command("cat", "purplpkg/versions/"+pName)
		curlinstalledoutput, _ := curlinstalledget.Output()
		curlinstalled := string(curlinstalledoutput)
		//fmt.Println(curlinstalled)

		if curllatest > curlinstalled {
			pName := os.Args[2]
			url := mirrorMain + pName + ".ppkg"
			version := mirrorMain + pName + ".version"
			fmt.Println("Installed version of " + pName + " is older than available package online. Upgrading...")
			fmt.Println("Installing package", pName)
			versioning := exec.Command("curl", "-o", "purplpkg/versions/"+pName+"", version)
			versioning.Run()
			fmt.Println("Version downloaded successfully")
			download := exec.Command("curl", "-o", "purplpkg/"+pName+".ppkg", url)
			download.Run()
			fmt.Println("Package downloaded")
			unzip := exec.Command("gunzip", "purplpkg/"+pName+".ppkg")
			unzip.Run()
			fmt.Println("Package decompressed")
			install := exec.Command("tar", "-xvf", "purplpkg/"+pName+".tar", "-C", "purplpkg")
			install.Run()
			fmt.Println("Package installed")
			clean := exec.Command("rm", ""+pName+".ppkg", ""+pName+".tar")
			clean.Run()
			fmt.Println("Done.")
			os.Exit(0)
		} else if curlinstalled == curllatest {
			fmt.Println("Installed version of " + pName + " is up-to-date.")
			os.Exit(0)
		}
		os.Exit(0)
	}
	fmt.Println("unknown action")
	os.Exit(1)
}
