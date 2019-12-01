FROM ubuntu

WORKDIR /tmp

RUN apt-get update \
    && apt-get install -y wget unzip git \
    && wget https://releases.hashicorp.com/terraform/0.12.6/terraform_0.12.6_linux_amd64.zip \
    && unzip terraform_0.12.6_linux_amd64.zip \
    && mv terraform /usr/local/bin/

WORKDIR /workspace

RUN git config --global user.email "ScottBouloutian@gmail.com" \
    && git config --global user.name "Scott Bouloutian" \
    && terraform init terraform \
    && apt-get install -y graphviz
