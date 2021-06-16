Racketscript Playground
=======================

Playground
for [RacketScript](https://github.com/vishesh/racketscript).  Visit
http://rapture.twistedplane.com:8080 to try. Both server-side and
client-side code is written in RacketScript.

Playground uses Github Gist to save and load files. The name of Gist
file must be `source.rkt`.

- URL of format `/#gist/:id` will load gist of that provided id.
- URL of format `/#example/:id` will download
  `$ROOT_URL/examples/:id.rkt` from server.
- A `POST /compile` request will take JSON payload of format: `{
  "code": <racket-code> }` and return a compiled JS file in reponse.

[CoreMirror](https://codemirror.net/) is used as editor
component. Search and Replace shortcuts
are [here](https://codemirror.net/demo/search.html).

## Build and Deploy

### With Docker (for deployment)

Easiest way is to pull the latest image from Docker registry
([vishesh/racket-script-playground](https://hub.docker.com/r/vishesh/racketscript-playground)).

```bash
# Pull docker image
docker pull vishesh/racketscript-playground

# Run playground webserver on port 8080
docker run -dp 8080:8080 -t vishesh/racketscript-playground
```

You can also build image yourself using `make docker-build`, followed by `make
docker-run` to start the playground web server. By default, `make docker-run`
binds webserver to port 8080.

### Without Docker (for development)

After installing Racket, NodeJS, and RacketScript, execute following
commands to run the playground:

```bash
make -j4 run
```

For development, you can use `quickrun`, after runnning `run` once,
for building both server and client without npm install/update:

```bash
make -j4 quickrun
```

## License

RacketScript is licensed under [MIT license](LICENSE). Third-party
libraries can be found over [here](static/index.html)
and [here](package.json).
