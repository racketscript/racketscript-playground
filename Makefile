.PHONY: quickbuild quickrun run clean
RACKS_FLAGS = --enable-self-tail --enable-flatten-if --js-beautify
RACKS_APP_FLAGS = --skip-arity-checks

run: build
	node ./build/server/dist/modules/app.rkt.js
run-forever: build
	while true; do make run; sleep 1; done

quickrun: quickbuild
	node ./build/server/dist/modules/app.rkt.js

quickbuild: RACKS_ARGS = -n
quickbuild: build

build: build/client build/server

build/server: app.rkt | node_modules
	@echo "Compiling the server..."
	racks $(RACKS_FLAGS) $(RACKS_ARGS) $(RACKS_APP_FLAGS) -d build/server --target babel app.rkt
node_modules: package.json package-lock.json
	npm install && touch node_modules

build/client: client.rkt | build/runtime build/examples
	@echo "Compiling the client..."
	racks $(RACKS_FLAGS) $(RACKS_ARGS) $(RACKS_APP_FLAGS) -d build/client client.rkt

build/runtime: stub.rkt
	@echo "Compiling the runtime..."
	racks -d build/runtime stub.rkt

build/examples: $(addsuffix .js,$(wildcard examples/*.rkt))
examples/%.rkt.js: examples/%.rkt
	@echo "Compiling $<..."
	racks $(RACKS_FLAGS) -ngd build/examples $<
	cp build/examples/modules/$*.rkt.js examples/

clean:
	rm -rf build/ examples/*.rkt.js

