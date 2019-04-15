FROM ubuntu:devel

MAINTAINER Alex Gonzalez <alex.gonzalez@digi.com>

ARG DEBIAN_FRONTEND=noninteractive

# Update Ubuntu 
RUN apt-get update && apt-get install -y build-essential git qt5-default qtquickcontrols2-5-dev qml-module-qtwayland-compositor qtwayland5-dev-tools qtwebengine5-dev-tools qtwebengine5-private-dev qtwebengine5-dev qtmultimedia5-dev libqt5xdg-dev qt5-doc qttools5-dev qbs qtchooser libwayland-dev libqt5xdg-dev libpam0g-dev libpolkit-qt5-1-dev libpolkit-gobject-1-dev libkf5solid-dev libsystemd-dev libdrm-dev libgbm-dev libinput-dev libxcb-cursor-dev libxcursor-dev libpulse-dev libkf5networkmanagerqt-dev modemmanager-qt-dev libglib2.0-dev dconf-service dconf-cli dconf-gsettings-backend libpipewire-0.2-dev gstreamer1.0-pipewire libxkbcommon-dev gstreamer1.0-qt5 libflatpak-dev libappstreamqt-dev python && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install Lirios
ENV LIRI_INSTALL_PATH="/usr/local/liri-source"
ENV REPO_INSTALL_PATH="/usr/local/bin/"
ENV LIRIDIR="/usr/local/liri-build"

RUN install -o 1000 -g 1000 -d $LIRI_INSTALL_PATH && install -o 1000 -g 1000 -d $REPO_INSTALL_PATH && install -o 1000 -g 1000 -d $LIRIDIR  && groupadd -g 1000 builder && useradd -u 1000 -g 1000 -ms /bin/bash builder
WORKDIR $LIRI_INSTALL_PATH
USER builder

RUN curl -o /usr/local/bin/repo http://commondatastorage.googleapis.com/git-repo-downloads/repo && chmod a+x /usr/local/bin/repo && cd $LIRI_INSTALL_PATH && repo init -u https://github.com/lirios/lirios.git -b develop && repo sync -j4 --no-repo-verify && repo forall -c 'git checkout $REPO_RREV; git submodule update --init --recursive' && ROOTDIR=$(pwd) repo forall -c 'git config commit.template $ROOTDIR/.commit-template' &&  echo "echo Welcome to LIRIOS builder docker image!" >> $HOME/.bashrc && cd $LIRIDIR

SHELL ["/bin/bash", "-c", "source $LIRI_INSTALL_PATH/env-setup.sh"]
