.PHONY: quickbuild quickrun run clean
RACKS_FLAGS = --enable-self-tail --enable-flatten-if --js-beautify
RACKS_APP_FLAGS = --skip-arity-checks
RACKS_EXAMPLE_FLAGS = --skip-arity-checks
# DOCKER_BUILD_DEBUG_FLAGS= --progress plain --no-cache

### Run playground

run: build
	node ./build/server/modules/app.rkt.js
run-forever: build
	while true; do make run; sleep 1; done

quickrun: quickbuild
	node ./build/server/modules/app.rkt.js

### Docker

docker-build:
	docker build $(DOCKER_BUILD_DEBUG_FLAGS) -t vishesh/racketscript-playground .

docker-run:
	docker run -dp 8080:80 -e PORT=80 -t vishesh/racketscript-playground

docker-push:
	docker push vishesh/racketscript-playground:latest

#### Build

quickbuild: RACKS_ARGS = -n
quickbuild: build

build: build/client build/server

build/server: app.rkt | node_modules
	@echo "Compiling the server..."
	racks $(RACKS_FLAGS) $(RACKS_ARGS) $(RACKS_APP_FLAGS) -d build/server app.rkt
node_modules: package.json package-lock.json
	npm install && touch node_modules

build/client: client.rkt | build/runtime build/examples
	@echo "Compiling the client..."
	racks $(RACKS_FLAGS) $(RACKS_ARGS) $(RACKS_APP_FLAGS) -d build/client --target webpack client.rkt
	./build/client/node_modules/.bin/webpack --config ./build/client/webpack.config.js --entry ./build/client/modules/client.rkt.js --output-path ./build/client/dist

build/runtime: stub.rkt
	@echo "Compiling the runtime..."
	racks $(RACKS_FLAGS) $(RACKS_EXAMPLE_FLAGS) -d build/runtime stub.rkt

build/examples: $(addsuffix .js,$(wildcard examples/*.rkt))
examples/%.rkt.js: examples/%.rkt
	@echo "Compiling $<..."
	racks $(RACKS_FLAGS) $(RACKS_ARGS) $(RACKS_EXAMPLE_FLAGS) -d build/examples $<
	cp build/examples/modules/$*.rkt.js examples/

clean:
	rm -rf build/ examples/*.rkt.js
