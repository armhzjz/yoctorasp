SUMMARY = "Simple image with k3s installed (as node)"
LICENSE = "MIT"

inherit core-image extrausers

CORE_IMAGE_EXTRA_INSTALL:append " packagegroup-k3s-node kernel-modules"

IMAGE_INSTALL:append = " \
                        packagegroup-demos-x11-minibase \
                        linux-firmware-rpidistro-bcm43430 \
                        "
SYSTEMD_DEFAULT_TARGET="graphical.target"
IMAGE_FEATURES:append = " \
                        ${EXTRA_IMAGE_FEATURES} \
                        virt-unique-hostname \
                        package-management \
                         "
IMAGE_FEATURES[validitems] += " virt-unique-hostname"

IMAGE_FEATURES:remove = "allow-empty-password empty-root-password"

# EXTRA_USERS_PARAMS = "usermod -p `openssl passwd -salt "WG" sldkfjgh` root;"
EXTRA_USERS_PARAMS = "usermod -p WGWP2ElxIb6ZY root; useradd -p `openssl passwd -salt "WG" ivyopwer` pfol;"
