.PHONY: build quickbuild run

FLAGS=--enable-self-tail --js-beautify

build:
	racks $(FLAGS) --target babel app.rkt
	racks $(FLAGS) --js client.rkt > ./static/modules/main.js

quickbuild:
	racks $(FLAGS) -n --target babel app.rkt
	racks $(FLAGS) --js client.rkt > ./static/modules/main.js

run:
	node ./js-build/dist/modules/app.rkt.js
