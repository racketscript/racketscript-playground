# syntax=docker/dockerfile:1
FROM ubuntu:rolling

WORKDIR /root
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update
RUN apt install -y software-properties-common curl build-essential git
RUN add-apt-repository -y ppa:plt/racket
RUN apt update
RUN apt install -y racket

RUN curl -O https://nodejs.org/dist/v14.17.1/node-v14.17.1-linux-x64.tar.xz
RUN tar xvf node-v14.17.1-linux-x64.tar.xz -C .
ENV PATH="/root/node-v14.17.1-linux-x64/bin:${PATH}"
RUN npm install -g js-beautify

RUN raco setup --doc-index --force-user-docs
RUN git clone https://github.com/vishesh/racketscript.git
WORKDIR /root/racketscript
RUN make setup

COPY . /root/racketscript-playground
ENV PATH="/root/racketscript/racketscript-compiler/bin/:${PATH}"

WORKDIR /root/racketscript-playground
RUN make build || true
CMD ["make", "run-forever"]
