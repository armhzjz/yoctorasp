SUMMARY = "Sample image that runs minesweeper at boot up"
LICENSE = "MIT"

inherit core-image extrausers

IMAGE_INSTALL:append = " \
                        packagegroup-demos-x11-minibase \
                        minesweeper \
                        linux-firmware-rpidistro-bcm43430 \
                        "
SYSTEMD_DEFAULT_TARGET="graphical.target"
IMAGE_FEATURES:append = " \
                        ${EXTRA_IMAGE_FEATURES} \
                         "

IMAGE_FEATURES:remove = "allow-empty-password empty-root-password"

# EXTRA_USERS_PARAMS = "usermod -p `openssl passwd -salt "WG" sldkfjgh` root;"
EXTRA_USERS_PARAMS = "usermod -p WGWP2ElxIb6ZY root; useradd -p `openssl passwd -salt "WG" ivyopwer` pfol;"
