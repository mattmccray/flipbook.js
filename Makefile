build:
	./node_modules/.bin/assembot build


gzip:
	gzip --stdout --best public/flipbook.js > public/flipbook.js.gz
	#gzip --stdout --best public/flipbook.core.js > public/flipbook.core.js.gz

clean:
	rm public/flipbook.*

SRC=$(shell find  src -name "*.coffee")

exp:
	coffee -b -p -c -j $(SRC) > theworks.js
	cat theworks.js | uglifyjs -m > theworks.min.js

test:
	@NODE_ENV=test
	@clear
	@./node_modules/.bin/mocha

.PHONY: build test
