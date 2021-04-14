SUMMARY = "Basic custom X11 session"
DESCRIPTION = "Packages required to set up a basic working X11 session (except the liberation-fonts)"
PR = "r0"

inherit packagegroup features_check

REQUIRED_DISTRO_FEATURES = "x11"

RDEPENDS_${PN} = "\
    packagegroup-core-x11-xserver \
    packagegroup-core-x11-utils \
    dbus \
    matchbox-terminal \
    matchbox-wm \
    mini-x-session \
    liberation-fonts \
    "
