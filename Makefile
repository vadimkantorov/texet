test/test.txt:
	mkdir -p test
	echo "console.log('Hello world')" > test/test.txt

test/test.pdf:
	mkdir -p test
	wget -O test/test.pdf https://raw.githubusercontent.com/mozilla/pdf.js/ba2edeae/web/compressed.tracemonkey-pldi-09.pdf

test/test.png:
	mkdir -p test
	wget -O test/test.png https://www.google.fr/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png

test/test.svg:
	mkdir -p test
	wget -O test/test.svg https://upload.wikimedia.org/wikipedia/commons/c/c3/Flag_of_France.svg

cat.js: test/test.txt test/test.pdf test/test.png test/test.svg
	emcc cat.c --preload-file test -s INVOKE_RUN=0 -s EXPORTED_FUNCTIONS='["_main"]' -s EXPORTED_RUNTIME_METHODS='["ccall", "cwrap"]' -o cat.js 

clean:
	rm *.js *.data *.wasm

.PHONY: clean
