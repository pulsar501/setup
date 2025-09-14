FROM docker.io/library/ubuntu:24.04

ENV TZ="Europe/Berlin"

ENV USER=p
ARG PASS=p

# update
RUN apt update -qqq && apt upgrade -y && apt dist-upgrade -y && apt autoremove -y
RUN apt install sudo git -y

RUN  echo "$TZ" > /etc/timezone \
  DEBIAN_FRONTEND=noninteractive apt install -y tzdata \
  dpkg-reconfigure --frontend noninteractive tzdata

# add user
RUN useradd -ms /bin/bash $USER
RUN echo "${USER}:${PASS}" | chpasswd
RUN usermod -aG sudo $USER

ENV PATH="$PATH:/home/${USER}/.local/bin"
USER $USER

WORKDIR /home/$USER


