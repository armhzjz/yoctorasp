# syntax=docker/dockerfile:1.2
FROM    crops/poky:ubuntu-20.04
# swtich to root user to install additional packages
USER    root
# create a non-root user
ARG     USERNAME=builder
ARG     GROUPNAME=build
ARG     USER_UID=1024
ARG     USER_GID=1024
RUN     set -x && \
        groupadd \
                --gid ${USER_GID} \
                ${GROUPNAME} \
                && \
        useradd \
                --uid ${USER_UID} \
                --gid ${USER_GID} \
                --create-home \
                ${USERNAME} \
        && \
        :
# update gcc version to 9
RUN	set -x && \
	apt update && \
	apt install software-properties-common -y && \
	#apt update && \
	add-apt-repository ppa:ubuntu-toolchain-r/ppa && \
	#apt update && \
	apt install g++-9 -y && \
	add-apt-repository --remove ppa:ubuntu-toolchain-r/ppa -y && \
	apt --purge autoremove software-properties-common -y && \
	update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-9 60 && \
	update-alternatives --config g++ && \
	update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-9 60 && \
	update-alternatives --config g++ && \
	:
# add additional packages
RUN     set -x && \
        apt update && \
        apt install -y \
                sudo \
                vim \
                less \
                bsdmainutils \
                nasm \
                mc \
                libncurses5-dev \
                libncursesw5-dev \
                python3 \
                python3-pip \
                && \
        echo ${USERNAME} ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/${USERNAME} && \
        chmod 0400 /etc/sudoers.d/${USERNAME} && \
        apt clean && \
        rm -fr /var/lib/apt/lists/* && \
        :
# install kas
RUN     set -x && \
        pip3 install kas && \
        :
# switch back to regular user
#USER    usersetup
USER builder
# Install fuzzy finder
RUN     git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
RUN     cd ~/.fzf && ./install
RUN     export USER=builder