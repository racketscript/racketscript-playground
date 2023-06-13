# syntax=docker/dockerfile:1
FROM racket/racket:8.7-full

RUN apt-get update -y --allow-releaseinfo-change \
    && apt-get install -y --no-install-recommends xz-utils make \
    && apt-get clean

WORKDIR /app
RUN curl -O https://nodejs.org/dist/v18.16.0/node-v18.16.0-linux-x64.tar.xz
RUN tar xvf node-v18.16.0-linux-x64.tar.xz -C .
ENV PATH="/app/node-v18.16.0-linux-x64/bin:${PATH}"
RUN npm install -g js-beautify

COPY . /app/racketscript-playground
ENV PATH="/root/.local/share/racket/8.7/bin/:${PATH}"
RUN raco pkg install --auto racketscript

WORKDIR /app/racketscript-playground
RUN make build || true
CMD ["make", "run-forever"]
