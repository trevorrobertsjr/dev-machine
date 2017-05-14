FROM ubuntu:latest

MAINTAINER Youcef Rahal

RUN apt-get update --fix-missing

# Install x11vnc and dependencies
# Install icewm (window manager)
# Install xz-utils
# Install cmake
# Install screen
# Install git and some UI utilities
# Install utilities
# Qt5 and QtCreator
# Dependencies on which Visual Studio Code depends
# Firefox
RUN apt-get install -y x11vnc xvfb \
                       icewm \
                       xz-utils \
                       cmake \
                       screen \
                       git gitk git-gui \
                       wget bzip2 vim nano \
                       qt5-default qtcreator \
                       libnss3 libnotify4 \
                       firefox

# RUN DEBIAN_FRONTEND=noninteractive apt-get install -y kubuntu-desktop
# Install Konsole
RUN apt-get install -y konsole

# Fetch and install Visual Studio Code
RUN wget https://az764295.vo.msecnd.net/stable/f6868fce3eeb16663840eb82123369dec6077a9b/code_1.12.1-1493934083_amd64.deb -O code.deb && \
    dpkg -i code.deb && \
    rm code.deb

# Fetch and install NodeJS
RUN wget https://nodejs.org/dist/v7.10.0/node-v7.10.0-linux-x64.tar.xz -O node.tar.xz && \
    tar xvf node.tar.xz && \
    mv node-* /opt/node && \
    rm node.tar.xz

# Clean
RUN apt-get clean

# Add a user
RUN useradd -m -s /bin/bash orion

# The next commands will be run as the new user
USER orion

# Add NodeJS to the PATH
ENV PATH /opt/node/bin:$PATH

# Create some useful default aliases
RUN bash -c 'echo "alias cp=\"cp -i\"" >> ~/.bash_aliases' && \
    bash -c 'echo "alias mv=\"mv -i\"" >> ~/.bash_aliases' && \
    bash -c 'echo "alias rm=\"rm -i\"" >> ~/.bash_aliases'

# Auto start icewm in the ~/.bashrc (if it's not running)
RUN bash -c 'echo "if ! pidof -x \"icewm\" > /dev/null; then nohup icewm &>> ~/icewm.log & fi" >> ~/.bashrc'

# Set the working directory
WORKDIR /src

# The port where x11vnc will be running
EXPOSE 5900

# Run x11vnc on start
CMD x11vnc -create -forever -usepw -repeat
