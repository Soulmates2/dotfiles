# FROM pytorch/pytorch:1.9.1-cuda11.1-cudnn8-devel
FROM pytorch/pytorch:2.0.0-cuda11.7-cudnn8-devel
# To dismiss interactive messages while installing packages
ARG DEBIAN_FRONTEND=noninteractive

# set a user name and a password 
ARG USER_NAME=geometry
ARG PASSWORD=geometry

# UID and GID should be manually declared when building Dockerfile.
# e.g. docker build --build-arg UID=$UID
ARG UID

# install some essential packages
RUN apt-get update && apt-get install -y \
    apt-utils \
    x11-apps \
    eog \
    build-essential \
    curl \
    git \
    man \
    wget \
    aria2 \
    zip \
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
    zsh && \
    apt-get -y autoremove && apt-get -y clean

# for libigl
RUN apt-get install -y \
    xorg-dev \
    freeglut3 \
    freeglut3-dev \
    mesa-common-dev \
    libosmesa6-dev \
    libgl1-mesa-dev \
    libglu1-mesa-dev \
    libx11-dev \
    libxi-dev \
    libxmu-dev \
    libgflags-dev \
    libgoogle-glog-dev \
    libgmp3-dev \
    libmpfr-dev \
    libhdf5-serial-dev && \
    apt-get -y autoremove && apt-get -y clean

# for ImageMagick
RUN apt-get install -y libjpeg62-dev 
RUN apt-get install -y libtiff-dev 


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
RUN groupadd -g $UID $USER_NAME
RUN useradd -u $UID -g $UID $USER_NAME && echo "${USER_NAME}:${PASSWORD}" | chpasswd && adduser $USER_NAME sudo
USER $USER_NAME

WORKDIR /home/$USER_NAME
EXPOSE 22
