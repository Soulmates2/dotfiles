FROM pytorch/pytorch:1.9.1-cuda11.1-cudnn8-devel

# To dismiss interactive messages while installing packages
ARG DEBIAN_FRONTEND=noninteractive

# set a user name and a password 
ARG USER_NAME=geometry
ARG PASSWORD=geometry

# UID and GID should be manually declared when building Dockerfile.
# e.g. docker build --build-arg UID=$UID --build-arg GID=$GID
ARG UID
ARG GID

# To solve GPG error (public key)
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3bf863cc
# RUN apt-key del 7fa2af80 && apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/3bf863cc.pub

# install some essential packages
RUN apt-get update && apt-get install -y \
	apt-utils \
	build-essential \
    curl \
    git \
    man \
    wget \
    htop \
    vim \
    nano \
    ctags \
	openssh-server \
	sudo \
    tmux \
	cmake \
    software-properties-common \
    libgl1-mesa-glx \
	locales \
    tzdata \
    xorg \
	zsh && \
	apt-get -y autoremove && apt-get -y clean

# set a timezone as Asia/Seoul
ENV TZ Asia/Seoul
RUN ln -snf /usr/share/zoneinfo/Asia/Seoul /etc/localtime && echo Asia/Seoul > /etc/timezone

# set the locale
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8

# allow root to login
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
RUN systemctl enable ssh


# set the root password
RUN echo "root:root" | chpasswd 

# add a user
RUN groupadd -g $GID $USER_NAME
RUN useradd -u $UID -g $GID $USER_NAME && echo "${USER_NAME}:${PASSWORD}" | chpasswd && adduser $USER_NAME sudo

USER $USER_NAME

WORKDIR /home/$USER_NAME
EXPOSE 22
