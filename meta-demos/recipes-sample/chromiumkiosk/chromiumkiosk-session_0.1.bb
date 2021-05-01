SUMMARY = "Sample image using chromium in kiosk mode"
DESCRIPTION = "A sample image using chromium in kiosk mode"

LICENSE = "Unlicense"
LIC_FILES_CHKSUM = "file://${WORKDIR}/LICENSE;md5=6c85ef3aa8c072d95e1dfb3e55ccf8cf"

SRC_URI = " \
           file://LICENSE \
           file://session \
           "

# Modify these as desired
PV = "0.1"

S = "${WORKDIR}"

do_install_append() {
    install -d ${D}${sysconfdir}/mini_x
    install -m 0755 ${WORKDIR}/session ${D}${sysconfdir}/mini_x/
}
