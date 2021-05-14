SUMMARY = "Sample image with greengrass version one on it as a demo."
LICENSE = "MIT"

inherit core-image extrausers

IMAGE_INSTALL_append = " \
                        packagegroup-demos-x11-minibase \
                        linux-firmware-rpidistro-bcm43430 \
			openjdk-8 \
			greengrass-bin \
                        "
SYSTEMD_DEFAULT_TARGET="graphical.target"
IMAGE_FEATURES_append = " \
                        ${EXTRA_IMAGE_FEATURES} \
                         "

IMAGE_FEATURES_remove = "allow-empty-password empty-root-password"

# EXTRA_USERS_PARAMS = "usermod -p `openssl passwd -salt "WG" sldkfjgh` root;"
EXTRA_USERS_PARAMS = "usermod -p WGWP2ElxIb6ZY root; useradd -p `openssl passwd -salt "WG" ivyopwer` pfol;"
