build:
	time ./node_modules/.bin/assembot build


gzip:
	gzip --stdout --best public/flipbook.js > public/flipbook.js.gz
	#gzip --stdout --best public/flipbook.core.js > public/flipbook.core.js.gz

clean:
	rm public/flipbook.*

test:
	@NODE_ENV=test
	@clear
	@./node_modules/.bin/mocha

.PHONY: build clean gzip test 
