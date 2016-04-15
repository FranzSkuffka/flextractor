build:
	cp -R lib src
	coffee -c lib
	find lib -iname "*.coffee" -exec rm '{}' ';'

unbuild:
	rm -rf lib
	mv src lib

publish:
	make build
	npm publish .
	make unbuild

browserify:
	make build
	browserify Flextractor-browserify.js > Flextractor-browser.js
	make unbuild
