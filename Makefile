.PHONY: build quickbuild run setup build-client build-server clean _build

FLAGS=--enable-self-tail --js-beautify

fireup: clean setup build run

build: build-examples _build

quickbuild:
	make ARGS=-n _build

run:
	node ./js-build/dist/modules/app.rkt.js

setup:
	npm install
	racks -d out-runtime stub.rkt
	cp -a out-runtime/runtime static/
	cp -a out-runtime/links/ static/
	make build-examples

build-examples:
	for eg in `ls examples/*.rkt`; do \
		echo "compiling $$eg"; \
		racks --enable-self-tail -ngd out-examples $$eg; \
	done
	cp -a out-examples/modules/*.rkt.js examples/

build-client:
	racks $(FLAGS) $(ARGS) -d client-out client.rkt
	cp client-out/dist/compiled.js static/main.js

build-server:
	racks $(FLAGS) $(ARGS) --target babel app.rkt

_build:
	make ARGS=$(ARGS) build-client build-server

clean:
	rm -rf static/runtime
	rm -rf static/links
	rm -rf out-runtime
	rm -rf client-out
	rm -rf js-build
	rm -rf examples/*.js
	rm -rf out-examples

