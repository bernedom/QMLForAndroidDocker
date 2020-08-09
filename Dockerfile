FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN dpkg --add-architecture i386
RUN apt update 
RUN apt install -y locales qtcreator android-sdk git g++ libgl1-mesa-glx

RUN apt install sudo curl file 
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN groupadd -r builder && useradd --create-home --gid builder builder && echo 'user ALL=NOPASSWD: ALL' > /etc/sudoers.d/builder

USER builder 
WORKDIR /home/builder
ENV HOME /home/builder