FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN dpkg --add-architecture i386
RUN apt update 

#install basic development tooks
RUN apt install -y locales git g++ libgl1-mesa-glx cmake

#install android specific 
RUN apt install -y android-sdk 

#install Qt-specific stuff
RUN apt install -y qt5-default qtcreator

# packages used only to build the container 
RUN apt install -y sudo curl file 

# generate locales
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# create builder user
RUN groupadd -r builder && useradd --create-home --gid builder builder && echo 'user ALL=NOPASSWD: ALL' > /etc/sudoers.d/builder

USER builder 
WORKDIR /home/builder
ENV HOME /home/builder