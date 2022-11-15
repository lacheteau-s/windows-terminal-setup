FROM ubuntu:20.04

ARG USERNAME
ARG PASSWORD

RUN apt-get update && apt-get -y install sudo

RUN useradd -m $USERNAME && echo "$USERNAME:$PASSWORD" | chpasswd && adduser $USERNAME sudo

USER $USERNAME

CMD /bin/bash