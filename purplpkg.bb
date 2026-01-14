SUMMARY = "purplpkg"
DESCRIPTION = "purplpkg is a lightweight package manager for Vector written in Bash."
LICENSE = "CLOSED"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI = "file://purplpkg.sh"

do_install() {
    install -d ${D}${bindir}
    install -m 0755 ${UNPACKDIR}/purplpkg.sh ${D}${bindir}/purplpkg
}

FILES:${PN} = "${bindir}/purplpkg"
RDEPENDS:${PN} = "bash"
