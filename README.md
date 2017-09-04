Racketscript Playground
=======================

Playground
for [RacketScript](https://github.com/vishesh/racketscript).  Visit
http://rapture.twistedplane.com:8080 to try. Both server-side and
client-side code is written in RacketScript.

## Instructions

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

## Usage

After installing Racket, NodeJS, and RacketScript, execute following
commands to run the playground:

	$ make -j 4 run

For development, you can use `quickrun`, after runnning `run` once,
for building both server and client without npm install/update:

	$ make -j 4 quickrun

## License

RacketScript is licensed under [MIT license](LICENSE). Third-party
libraries can be found over [here](static/index.html)
and [here](package.json).
