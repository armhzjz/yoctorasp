SUMMARY = "Sample image thatruns minesweeper at boot up"
LICENSE = "MIT"

inherit core-image extrausers

IMAGE_INSTALL_append = " packagegroup-demos-x11-minibase minesweeper"
SYSTEMD_DEFAULT_TARGET="graphical.target"
IMAGE_FEATURES_append = " \
                        ${EXTRA_IMAGE_FEATURES} \
                         "

IMAGE_FEATURES_remove = "allow-empty-password empty-root-password"

# EXTRA_USERS_PARAMS = "usermod -p `openssl passwd -salt "WG" sldkfjgh` root;"
EXTRA_USERS_PARAMS = "usermod -p WGWP2ElxIb6ZY root; useradd -p `openssl passwd -salt "WG" ivyopwer` pfol;"


