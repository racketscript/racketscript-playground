.PHONY: build quickbuild run setup

FLAGS=--enable-self-tail --js-beautify

setup:
	racks -d _tmp stub.rkt
	rm -rf static/runtime
	rm -rf static/links
	cp -a _tmp/runtime static/
	cp -a _tmp/links/ static/
	rm -rf _tmp

build:
	make setup
	racks $(FLAGS) --target babel app.rkt
	racks $(FLAGS) -d client-out client.rkt
	cp client-out/dist/compiled.js static/main.js

quickbuild:
	racks $(FLAGS) -n --target babel app.rkt
	racks $(FLAGS) -nd client-out client.rkt
	cp client-out/dist/compiled.js static/main.js

run:
	node ./js-build/dist/modules/app.rkt.js
