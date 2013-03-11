build:
	./node_modules/.bin/assembot build

test:
	@NODE_ENV=test
	@clear
	@./node_modules/.bin/mocha

.PHONY: build test
