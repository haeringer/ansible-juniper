FROM python:3.7-slim

LABEL Name="exampleorg NOC Ansible for Junos Docker Image"

ARG WORKDIR=ansible-juniper
ARG USERNAME

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y vim openssh-client iputils-ping dnsutils

RUN mkdir -p /$WORKDIR
ADD . /$WORKDIR
WORKDIR /$WORKDIR

RUN pip3 install --upgrade pip
RUN pip3 install -r requirements.txt
RUN ansible-galaxy install -r requirements.yml

RUN useradd --create-home --shell /bin/bash $USERNAME
RUN chown -R $USERNAME:$USERNAME /$WORKDIR
USER $USERNAME
