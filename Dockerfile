FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN dpkg --add-architecture i386
RUN apt update 

#install basic development tooks
RUN apt install -y locales git g++ libgl1-mesa-glx cmake openssl openssh-client ca-certificates

#install android specific 
RUN apt install -y  gradle

#install Qt-specific stuff
RUN apt install -y qt5-default qtcreator libqt5qml5 libqt5quick5

# packages used only to build the container 
RUN apt install -y sudo curl file 

# generate locales
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# create builder user
RUN groupadd -r builder && useradd --create-home --gid builder builder && echo 'user ALL=NOPASSWD: ALL' > /etc/sudoers.d/builder

ENV ANDROID_HOME=/opt/android-sdk \
    ANDROID_NDK_ARCH=arch-arm \
    ANDROID_NDK_EABI=llvm \
    ANDROID_NDK_HOST=linux-x86_64 \
    ANDROID_NDK_TOOLCHAIN_PREFIX=arm-linux-androideabi \
    ANDROID_NDK_TOOLCHAIN_VERSION=4.9 \
    SDK_PLATFORM=android-21 \
    SDK_BUILD_TOOLS=29.0.2


ENV \
    ANDROID_SDK_ROOT=${ANDROID_HOME} \
    ANDROID_NDK_PLATFORM=${SDK_PLATFORM} \
    ANDROID_NDK_ROOT=${ANDROID_HOME}/ndk-${NDK_VERSION} \
    ANDROID_NDK_TOOLS_PREFIX=${ANDROID_NDK_TOOLCHAIN_PREFIX}    

#ARG NDK_VERSION=r19c

RUN mkdir /tmp/android &&\
    cd /tmp/android &&\
    curl -Lo ndk.zip "https://dl.google.com/android/repository/android-ndk-r19c-linux-x86_64.zip" && \
    unzip -q ndk.zip && \ 
    mv android-ndk-* $ANDROID_NDK_ROOT &&\
    chmod -R +rX $ANDROID_NDK_ROOT &&\
    rm -rf /tmp/android 

USER builder 
WORKDIR /home/builder
ENV HOME /home/builder