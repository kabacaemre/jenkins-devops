FROM jenkins/jenkins:lts
USER root
RUN apt update && apt -y dist-upgrade
RUN apt install -y unzip gettext-base wget vim tzdata libgl1-mesa-glx ffmpeg libsm6 libxext6 libxi6 libxtst6
RUN curl -fsSL https://get.docker.com | sh
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
RUN install -o root -g root -m 0755 kubectl /usr/bin/kubectl
ENV TZ=Europe/Istanbul
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN dpkg-reconfigure -f noninteractive tzdata

ADD test.yaml /root/kube/test.yaml
ADD id_rsa /root/.ssh/id_rsa
ADD id_rsa.pub /root/.ssh/id_rsa.pub

RUN chmod 700 /root/.ssh
RUN chmod 600 /root/.ssh/*

RUN ssh -o StrictHostKeyChecking=accept-new github.com || true

WORKDIR /tmp
RUN wget -c https://nodejs.org/download/release/v16.13.1/node-v16.13.1-linux-x64.tar.gz
WORKDIR /opt
RUN tar zxvpf /tmp/node-v16.13.1-linux-x64.tar.gz
RUN ln -sf /opt/node-v16.13.1-linux-x64 /opt/node

ENV PATH="$PATH:/opt/node/bin"

WORKDIR /var/jenkins_home/workspace