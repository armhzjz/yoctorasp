SUMMARY = "My ML portfolio on an embedded device"
LICENSE = "MIT"

IMAGE_FEATURES_append = ""
IMAGE_FEATURES_remove = "allow-empty-password empty-root-password"

IMAGE_INSTALL_append = " \
                        packagegroup-core-x11-xserver \
                        packagegroup-core-x11-utils \
                        dbus \
                        matchbox-terminal \
                        matchbox-wm \
                        mini-x-session \
                        liberation-fonts \
                        ${CORE_IMAGE_EXTRA_INSTALL} \
                        "

inherit core-image extrausers


# EXTRA_USERS_PARAMS = "usermod -p `openssl passwd -salt "WG" sldkfjgh` root;"
EXTRA_USERS_PARAMS = "usermod -p WGWP2ElxIb6ZY root;"


