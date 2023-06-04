FROM    crops/poky:ubuntu-22.04 AS dev
# swtich to root user to install additional packages
USER    root
# create a non-root user
ARG     USERNAME=builder
ARG     GROUPNAME=build
ARG     USER_UID=1000
ARG     USER_GID=1000
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
RUN     set -x && \
        apt update && \
        apt install -y \
        sudo \
        && \
        echo ${USERNAME} ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/${USERNAME} && \
        chmod 0440 /etc/sudoers.d/${USERNAME} && \
        apt clean && \
        rm -rf /var/lib/apt/lists/* && \
        :
# Switch to the non-root user
USER    ${USERNAME}
# Enable all aliases already defined in .bashrc
RUN     set -x && \
        sed --in-place \
        's/#alias/alias/g' \
        $HOME/.bashrc \
        && \
        :
# update gcc version to 9
RUN	set -x && \
	sudo --preserve-env apt update && \
	sudo --preserve-env apt install software-properties-common -y && \
	sudo --preserve-env add-apt-repository ppa:ubuntu-toolchain-r/ppa && \
	sudo --preserve-env apt install g++-9 -y && \
	sudo --preserve-env add-apt-repository --remove ppa:ubuntu-toolchain-r/ppa -y && \
	sudo --preserve-env apt --purge autoremove software-properties-common -y && \
	sudo --preserve-env update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-9 60 && \
	sudo --preserve-env update-alternatives --config g++ && \
	sudo --preserve-env update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-9 60 && \
	sudo --preserve-env update-alternatives --config g++ && \
	:
# add additional packages
RUN     set -x && \
        sudo --preserve-env apt update && \
        sudo --preserve-env apt install -y \
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
        sudo --preserve-env apt clean && \
        sudo --preserve-env rm -fr /var/lib/apt/lists/* && \
        :
# install kas
RUN     set -x && \
        pip3 install kas && \
        :
# Install fuzzy finder
RUN     git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
RUN     cd ~/.fzf && ./install
RUN     export USER=builder