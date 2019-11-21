FROM python:3.7-slim

LABEL Name="exampleorg NOC Ansible-Juniper Docker Image"

ARG key
ARG username

ARG workdir=ansible-juniper
ARG keypath=/home/$username/.ssh/
ARG keyfile=$keypath/id_rsa

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y vim openssh-client iputils-ping dnsutils

RUN mkdir -p /$workdir
ADD . /$workdir
WORKDIR /$workdir

RUN pip3 install --upgrade pip
RUN pip3 install -r requirements.txt

RUN useradd --create-home --shell /bin/bash $username
RUN chown -R $username:$username /$workdir
ENV USER=$username
USER $username

RUN ansible-galaxy install --roles-path ~/.ansible/roles -r requirements.yml

RUN mkdir -p $keypath && touch $keyfile
RUN echo $key | tr ';' '\n' > $keyfile && chmod 600 $keyfile
