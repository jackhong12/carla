From ubuntu:18.04

################################################################################
# first part
################################################################################
# ubuntu 20
ARG DEBIAN_FRONTEND=noninteractive
# ubuntu 18
ENV DEBIAN_FRONTEND=noninteractive
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime
RUN echo $TZ > /etc/timezone
ARG usern=envconf
ARG USER_UID=1000
ARG USER_GID=1000
RUN groupadd --gid $USER_GID $usern
RUN useradd --uid $USER_UID --gid $USER_GID -m $usern
RUN apt-get update && apt-get install --no-install-recommends -y \
    lsb-release \
    sudo \
    bash-completion \
    software-properties-common
RUN sudo apt-get install git -y

# language setting
RUN apt-get install -y locales
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN apt-get install debconf -y
RUN apt-get install keyboard-configuration -y
RUN dpkg-reconfigure keyboard-configuration

# change mirror url
#RUN sed -i 's/http:\/\/archive\.ubuntu\.com/http:\/\/free\.nchc\.org\.tw/g' /etc/apt/sources.list
#RUN sed -i 's/http:\/\/security\.ubuntu\.com/http:\/\/free\.nchc\.org\.tw/g' /etc/apt/sources.list
#RUN apt-get update

RUN echo "$usern ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$usern
RUN chmod 0440 /etc/sudoers.d/$usern
RUN chown -R $usern:$usern /home/$usern
ENV USER=$usern
ENV HOME=/home/$usern
USER $usern

################################################################################
# second part
################################################################################
WORKDIR /home/$usern

RUN git clone https://github.com/jackhong12/envconf.git
RUN cd envconf && \
    git submodule update --recursive --init && \
    bash -x ./scripts/zsh.sh -p10k -no-check && \
    bash -x ./scripts/tmux.sh -a -m -n
RUN sudo apt-get install vim -y
#RUN cd envconf && bash -x ./install.sh --omz-no-check
#
RUN sudo sed -i "s/\($usern:.*\/bin\/\)sh/\1zsh/g" /etc/passwd
RUN script -qc "bash -c \"zsh -is <<<''\"" /dev/null

################################################################################
# build carla
################################################################################
RUN mkdir -p $HOME/tools
COPY ./tools/prerequisites.sh $HOME/tools/prerequisites.sh
RUN bash -x $HOME/tools/prerequisites.sh

RUN sudo apt-get install build-essential clang-8 lld-8 g++-7 cmake ninja-build libvulkan1 -y
RUN sudo apt-get install python python-pip python-dev python3-dev python3-pip libpng-dev libtiff5-dev -y
RUN sudo apt-get install libjpeg-dev sed curl unzip autoconf libtool rsync libxml2-dev git -y

RUN sudo apt-get update && sudo apt-get install tzdata -y

RUN sudo update-alternatives --install /usr/bin/clang++ clang++ /usr/lib/llvm-8/bin/clang++ 180 && \
    sudo update-alternatives --install /usr/bin/clang clang /usr/lib/llvm-8/bin/clang 180

RUN pip3 install --upgrade pip
RUN pip install --upgrade pip

RUN pip install --user setuptools && \
    pip3 install --user -Iv setuptools==47.3.1 && \
    pip install --user distro && \
    pip3 install --user distro && \
    pip install --user wheel && \
    pip3 install --user wheel auditwheel

# Unreal Engine
RUN sudo apt-get install xdg-user-dirs -y
COPY UnrealEngine_4.26 $HOME/UnrealEngine_4.26
RUN cd $HOME/UnrealEngine_4.26
RUN bash -x ./Setup.sh
