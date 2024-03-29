SUMMARY = "Sample image with greengrass version one on it as a demo."
LICENSE = "MIT"

inherit core-image extrausers

AWS_IOT_GG = "greengrass-bin                         \
              ntp                                    \
              docker                                 \
              python3-docker-compose                 \
              "

RPI_WIFI =   "crda                                   \
              iw                                     \
              wpa-supplicant                         \
              "

RPI_NET =    "i2c-tools                              \
              python3-smbus                          \
              bridge-utils                           \
              hostapd                                \
              dhcpcd	                             \
              iptables                               \
              wpa-supplicant                         \
              "

IMAGE_INSTALL:append = " \
                        packagegroup-demos-x11-minibase     \
                        linux-firmware-rpidistro-bcm43430   \
                        openjdk-8                           \
                        strace                              \
                        ${AWS_IOT_GG}                       \
                        ${RPI_WIFI}                         \
                        ${RPI_NET}                          \
                        "

SYSTEMD_DEFAULT_TARGET="graphical.target"
DISTRO_FEATURES += "virtualization"
IMAGE_FEATURES:append = " \
                        ${EXTRA_IMAGE_FEATURES}         \
                        ssh-server-dropbear             \
                         "

IMAGE_FEATURES:remove = "allow-empty-password empty-root-password"

# EXTRA_USERS_PARAMS = "usermod -p `openssl passwd -salt "WG" sldkfjgh` root;"
EXTRA_USERS_PARAMS = " \
	usermod -p WGWP2ElxIb6ZY root; \
	useradd -p `openssl passwd -salt "WG" ivyopwer` pfol; \
	usermod -a -G docker pfol; \
	"
