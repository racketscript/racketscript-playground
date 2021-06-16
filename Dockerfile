# syntax=docker/dockerfile:1
FROM racket/racket:8.1-full

WORKDIR /app
RUN curl -O https://nodejs.org/dist/v14.17.1/node-v14.17.1-linux-x64.tar.xz
RUN tar xvf node-v14.17.1-linux-x64.tar.xz -C .
ENV PATH="/app/node-v14.17.1-linux-x64/bin:${PATH}"
RUN npm install -g js-beautify

COPY . /app/racketscript-playground
ENV PATH="/root/.local/share/racket/8.1/bin/:${PATH}"
RUN raco pkg install --auto racketscript

WORKDIR /app/racketscript-playground
RUN make build || true
CMD ["make", "run-forever"]
