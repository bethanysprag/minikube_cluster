FROM ubuntu:22.04 as base

LABEL maintainer="Bethany Sprague, bsprague@scitec.com"

RUN apt-get update -y && \
    apt-get install -y  g++ make automake git wget lsof curl \
                    nano zip python3-pip \
                    openssh-server 

WORKDIR /work
COPY requirements.txt /work/requirements.txt
RUN pip install --upgrade pip 
RUN --mount=type=cache,target=/root/.cache \
    pip install -r requirements.txt

FROM base as minikube
WORKDIR /work
COPY scripts/ .
RUN ./install_docker.sh
RUN ./install_kompose.sh
RUN wget https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && \
    install minikube-linux-amd64 /usr/local/bin/minikube
RUN ./install_helm.sh

ARG DOCKER_GID=$DOCKER_GID
RUN groupadd -r kubeuser && useradd -l -r -m -g kubeuser -u 1000 kubeuser && \
    usermod -aG docker kubeuser && \
    groupmod -g $DOCKER_GID docker

USER root
WORKDIR /home/kubeuser
COPY test/ test
RUN chown -R kubeuser test
USER kubeuser
CMD minikube start
