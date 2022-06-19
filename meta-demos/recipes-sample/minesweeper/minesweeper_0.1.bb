SUMMARY = "Minesweeper game as a wxWidgets application sample."
DESCRIPTION = "A sample piece of software used for cross-compilation examples and tests"
HOMEPAGE = "https://github.com/armhzjz/minesweeper-in-wxwidgets"

LICENSE = "Unlicense"
LIC_FILES_CHKSUM = "file://LICENSE;md5=d88e9e08385d2a17052dac348bde4bc1"

SRC_URI = " \
           git://github.com/armhzjz/minesweeper-in-wxwidgets.git;protocol=https;branch=master \
           file://session \
"

# Modify these as desired
PV = "0.1+git${SRCPV}"
SRCREV = "38c160d393def45548c5e54721a06fdfbe5922c9"

S = "${WORKDIR}/git"

DEPENDS = "boost wxwidgets"

inherit cmake

do_install:append() {
    install -d ${D}${sysconfdir}/mini_x
    install -m 0755 ${WORKDIR}/session ${D}${sysconfdir}/mini_x/
}

# Specify any options you want to pass to cmake using EXTRA_OECMAKE:
EXTRA_OECMAKE = ""
