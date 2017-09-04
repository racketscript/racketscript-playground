.PHONY: quickbuild clean run setup
RACKS_FLAGS = --enable-self-tail --enable-flatten-if --js-beautify

build: build/client build/server

quickbuild: RACKS_ARGS = -n
quickbuild: build

run: build
	node ./build/server/dist/modules/app.rkt.js
quickrun: quickbuild
	node ./build/server/dist/modules/app.rkt.js

node_modules: package.json
	npm install
examples/%.rkt.js: examples/%.rkt
	@echo "Compiling $<..."
	racks $(RACKS_FLAGS) -ngd build/examples $<
	cp build/examples/modules/$*.rkt.js examples/
build/examples: $(addsuffix .js,$(filter-out examples/default.rkt,\
$(wildcard examples/*.rkt)))

static/main.js: client.rkt
	@echo "Compiling the client..."
	racks $(RACKS_FLAGS) $(RACKS_ARGS) -d build/client client.rkt
	cp build/client/dist/compiled.js static/main.js
build/runtime: stub.rkt
	racks -d build/runtime stub.rkt
static/runtime: | build/runtime
	ln -sf ../build/runtime/runtime static/runtime
static/links: | build/runtime
	ln -sf ../build/runtime/links static/links
static/collects: | build/runtime
	ln -sf ../build/runtime/collects static/collects
build/client: build/examples static/main.js node_modules | static/runtime static/links static/collects

build/server: app.rkt
	@echo "Compiling the server..."
	racks $(RACKS_FLAGS) $(RACKS_ARGS) -d build/server --target babel app.rkt

clean:
	rm -f static/runtime static/links static/collects
	rm -rf build/ **/*.rkt.js static/main.js

